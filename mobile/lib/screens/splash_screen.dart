import 'package:car_dashboard/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

    // The total time it takes for the entire word to finish animating
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Generate an animation for each individual letter
    _colorAnimations = List.generate(_title.length, (index) {
      // Stagger the start time of each letter (e.g., G starts at 0.0s, A at 0.1s, etc.)
      final double start = index * 0.1;
      final double end = (start + 0.5).clamp(0.0, 1.0);

      // This creates the "Neon Flicker" effect
      return TweenSequence<Color?>([
        // Flicker 1: Invisible -> Blue
        TweenSequenceItem(weight: 10, tween: ColorTween(begin: Colors.transparent, end: Colors.blueAccent)),
        // Flicker 2: Blue -> Invisible
        TweenSequenceItem(weight: 10, tween: ColorTween(begin: Colors.blueAccent, end: Colors.transparent)),
        // Flicker 3: Invisible -> Blue
        TweenSequenceItem(weight: 10, tween: ColorTween(begin: Colors.transparent, end: Colors.blueAccent)),
        // Settle: Blue -> White
        TweenSequenceItem(weight: 70, tween: ColorTween(begin: Colors.blueAccent, end: Colors.white)),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.linear),
        ),
      );
    });

    // Start the animation, then navigate when it completes
    _controller.forward().then((_) {
      _navigateToNextScreen();
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
    // TODO: When Sidharth's backend is ready, check the JWT token here.
    // For now, we will simulate that no user is logged in.
    bool isLoggedIn = false;

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