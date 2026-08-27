import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';
import '../home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // This single boolean controls the entire expanding/collapsing UI
  bool isLogin = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void toggleAuthMode() {
    // Clears the fields when switching modes so old passwords don't linger
    nameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    setState(() {
      isLogin = !isLogin;
    });
  }

  void authenticate() {
    if (!isLogin) {
      // REGISTER LOGIC
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match. Sync failed.")),
        );
        return;
      }

      // Simulate backend save...
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Created! Please log in to authorize access."),
          backgroundColor: Colors.green,
        ),
      );

      // Instantly fold the page back up into Login mode
      setState(() {
        isLogin = true;
      });

    } else {
      // LOGIN LOGIC
      // Simulate checking credentials...
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Icon
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isLogin ? Icons.lock_outline_rounded : Icons.add_moderator_outlined,
                    key: ValueKey(isLogin),
                    size: 80,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),

                // Universal Heading
                Text(
                  "GARAGE ACCESS",
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),

                // Animated Subtitle
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    isLogin ? "Enter credentials to sync telemetry." : "Register new profile to access garage.",
                    key: ValueKey(isLogin),
                    style: GoogleFonts.robotoMono(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // EXTRA FIELD 1: Driver Name (Expands/Collapses)
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  child: isLogin
                      ? const SizedBox.shrink() // Takes up zero space when logging in
                      : Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MyTextField(
                      controller: nameController,
                      hintText: "Driver Name",
                      obscureText: false,
                    ),
                  ),
                ),

                // CORE FIELDS: Always visible
                MyTextField(
                  controller: emailController,
                  hintText: "Email Address",
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                // EXTRA FIELD 2: Confirm Password (Expands/Collapses)
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  child: isLogin
                      ? const SizedBox.shrink()
                      : Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: MyTextField(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      obscureText: true,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Dynamic Button
                MyButton(
                  onTap: authenticate,
                  text: isLogin ? "INITIALIZE" : "REGISTER",
                ),
                const SizedBox(height: 30),

                // Bottom Toggle Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin ? "No garage profile?" : "Existing profile?",
                      style: GoogleFonts.robotoMono(color: Colors.white60),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: toggleAuthMode,
                      child: Text(
                        isLogin ? "Create one" : "Sync here",
                        style: GoogleFonts.robotoMono(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}