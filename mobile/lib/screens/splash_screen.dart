import 'package:car_dashboard/providers/auth_provider.dart';
import 'package:car_dashboard/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'auth/auth_screen.dart'; // Ensure this points to your AuthScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Color?>> _colorAnimations;

  final String _title = 'GARAGE';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _colorAnimations = List.generate(_title.length, (index) {
      final double start = index * 0.1;
      final double end = (start + 0.5).clamp(0.0, 1.0);

      return TweenSequence<Color?>([
        TweenSequenceItem(weight: 10, tween: ColorTween(begin: Colors.transparent, end: Colors.blueAccent)),
        TweenSequenceItem(weight: 10, tween: ColorTween(begin: Colors.blueAccent, end: Colors.transparent)),
        TweenSequenceItem(weight: 10, tween: ColorTween(begin: Colors.transparent, end: Colors.blueAccent)),
        TweenSequenceItem(weight: 70, tween: ColorTween(begin: Colors.blueAccent, end: Colors.white)),
      ]).animate(
        CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.linear)),
      );
    });

    // 1. WAIT FOR FLUTTER TO ACTUALLY RENDER THE FIRST FRAME
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 2. NOW start the 800ms delay to let the screen settle
      Future.delayed(const Duration(milliseconds: 800), () async {
        if (mounted) {
          await context.read<AuthProvider>().checkAuthStatus();
          // 3. START THE ANIMATION
          _controller.forward().then((_) {
            _navigateToNextScreen();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    // ---------------------------------------------------------
    // THE SMART GATE LOGIC
    // ---------------------------------------------------------
    // Read the actual authentication state from the provider
    final isLoggedIn = context.read<AuthProvider>().isAuthenticated;

    // Decide which screen to load based on the background check
    Widget nextScreen = isLoggedIn ? const HomeScreen() : const AuthScreen();
    // ---------------------------------------------------------

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        // Make the transition nice and slow (1.2 seconds)
        transitionDuration: const Duration(milliseconds: 1000),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {

          // 1. The Fade Effect
          var fadeAnimation = animation.drive(CurveTween(curve: Curves.easeInOut));

          // 2. The Smooth Slide Effect (Starts 15% lower and glides up)
          var slideAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.15),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuart, // A premium, decelerating curve
          ));

          // Combine them together!
          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // Build the row of animated letters
          children: List.generate(_title.length, (index) {
            return AnimatedBuilder(
              animation: _colorAnimations[index],
              builder: (context, child) {
                // We add a subtle glowing shadow when the color is blue
                final isSettled = _colorAnimations[index].value == Colors.white;

                return Text(
                  _title[index],
                  style: GoogleFonts.monoton(
                    textStyle: TextStyle(
                      fontSize: 48,
                      color: _colorAnimations[index].value,
                      letterSpacing: 4,
                      shadows: [
                        if (!isSettled) // Only glow during the blue flicker
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.8),
                            blurRadius: 15,
                            offset: Offset.zero,
                          )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}