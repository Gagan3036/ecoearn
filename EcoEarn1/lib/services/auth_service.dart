import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../pages/home/Home.dart';
import '../pages/login/login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Fluttertoast.showToast(
          msg: 'Verification email sent. Please check your inbox.',
          backgroundColor: Colors.green,
        );
      }

      await Future.delayed(const Duration(seconds: 1));
      // Navigation will be handled by StreamBuilder in main.dart
    } on FirebaseAuthException catch (e) {
      String message = _handleFirebaseAuthError(e);
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.black54);
    }
  }

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

      if (user != null && !user.emailVerified) {
        Fluttertoast.showToast(
          msg: 'Please verify your email before logging in.',
          backgroundColor: Colors.orange,
        );
        return;
      }

      await Future.delayed(const Duration(seconds: 1));
      // Navigation will be handled by StreamBuilder in main.dart
    } on FirebaseAuthException catch (e) {
      String message = _handleFirebaseAuthError(e);
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.black54);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      // Navigation will be handled by StreamBuilder in main.dart
    } catch (e) {
      Fluttertoast.showToast(msg: 'Google Sign-In failed. Try again.', backgroundColor: Colors.red);
    }
  }

  Future<void> signout({required BuildContext context}) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await Future.delayed(const Duration(seconds: 1));
      // Remove manual navigation; StreamBuilder will handle it
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error signing out: $e', backgroundColor: Colors.red);
    }
  }

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

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'invalid-email':
        return 'Invalid email address.';
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