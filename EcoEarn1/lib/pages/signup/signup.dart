import 'package:ecoearn/pages/login/login.dart';
import 'package:ecoearn/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _signUp(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Call the signup method without expecting a return value
    await AuthService().signup(
      email: email,
      password: password,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC8FACC), // Light green background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Register Account',
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _emailAddress(),
                const SizedBox(height: 20),
                _password(),
                const SizedBox(height: 30),
                _signupButton(context),
                const SizedBox(height: 20),
                _signin(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailAddress() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _password() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: "Password",
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _signupButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () => _signUp(context),
      child: const Text(
        "Sign Up",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _signin(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          const TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: "Log In",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
          ),
        ],
      ),
    );
  }
}
