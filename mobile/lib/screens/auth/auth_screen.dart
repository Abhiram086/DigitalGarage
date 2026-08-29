import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';
import '../../providers/auth_provider.dart';
import '../home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isProcessing = false;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void toggleAuthMode() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() => isLogin = !isLogin);
  }

  Future<void> authenticate() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final email = emailController.text.trim();

    // Grab our new AuthProvider
    final auth = context.read<AuthProvider>();

    // 1. BLANK FIELD CHECK
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in required fields.", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => isProcessing = true);

    if (!isLogin) {
      // 2. REGISTER LOGIC
      if (password != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match.", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
        );
        setState(() => isProcessing = false);
        return;
      }

      bool success = await auth.register(username, email, password);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Created! Please log in."), backgroundColor: Colors.green),
        );
        setState(() => isLogin = true); // Fold back into login mode automatically
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration failed. Username may exist.", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
        );
      }
    } else {
      // 3. LOGIN LOGIC
      bool success = await auth.login(username, password);
      if (success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid credentials.", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
        );
      }
    }

    setState(() => isProcessing = false);
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
                Text(
                  "GARAGE ACCESS",
                  style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    isLogin ? "Enter credentials to sync telemetry." : "Register new profile to access garage.",
                    key: ValueKey(isLogin),
                    style: GoogleFonts.robotoMono(fontSize: 14, color: Colors.white60),
                  ),
                ),
                const SizedBox(height: 40),

                MyTextField(controller: usernameController, hintText: "Username", obscureText: false),

                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  child: isLogin
                      ? const SizedBox.shrink()
                      : Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: MyTextField(controller: emailController, hintText: "Email Address", obscureText: false),
                  ),
                ),
                const SizedBox(height: 16),

                MyTextField(controller: passwordController, hintText: "Password", obscureText: true),

                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  child: isLogin
                      ? const SizedBox.shrink()
                      : Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: MyTextField(controller: confirmPasswordController, hintText: "Confirm Password", obscureText: true),
                  ),
                ),
                const SizedBox(height: 30),

                isProcessing
                    ? const CircularProgressIndicator(color: Colors.blueAccent)
                    : MyButton(onTap: authenticate, text: isLogin ? "INITIALIZE" : "REGISTER"),
                const SizedBox(height: 30),

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
                        style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold, color: Colors.blueAccent),
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