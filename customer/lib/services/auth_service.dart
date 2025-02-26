import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../pages/home/home.dart';
import '../pages/login/login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// ✅ **Sign Up (Register) with Email Verification**
  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Send Email Verification
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Fluttertoast.showToast(
          msg: 'Verification email sent. Please check your inbox.',
          backgroundColor: Colors.green,
        );
      }

      // Redirect to Login Page (NOT home page)
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
    } on FirebaseAuthException catch (e) {
      String message = _handleFirebaseAuthError(e);
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.black54);
    }
  }

  /// ✅ **Sign In (Login) - Blocks Unverified Users**
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Prevent login if email is not verified
      if (user != null && !user.emailVerified) {
        Fluttertoast.showToast(
          msg: 'Please verify your email before logging in.',
          backgroundColor: Colors.orange,
        );
        return;
      }

      // Login successful - Navigate to Home Page
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    } on FirebaseAuthException catch (e) {
      String message = _handleFirebaseAuthError(e);
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.black54);
    }
  }

  /// ✅ **Google Sign-In**
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      Fluttertoast.showToast(msg: 'Google Sign-In failed. Try again.', backgroundColor: Colors.red);
    }
  }

  /// ✅ **Sign Out**
  Future<void> signout({required BuildContext context}) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
  }

  /// ✅ **Reset Password**
  Future<void> resetPassword({required String email, required BuildContext context}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: 'Password reset email sent! Check your inbox.',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }

  /// ✅ **Handle Firebase Authentication Errors**
  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'invalid-email':
        return 'No user found for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      default:
        return 'Error: ${e.message}';
    }
  }
}
