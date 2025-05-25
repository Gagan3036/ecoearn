import 'package:flutter/material.dart';
import 'package:flutter_application/forgot_password.dart'; // <-- Add this
import 'package:flutter_application/login.dart';
import 'package:flutter_application/register.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyLogin(),
      routes: {
        'register': (context) => MyRegister(),
        'login': (context) => MyLogin(),
        'forgot': (context) => ForgotPassword(), // <-- Add this
      },
    ),
  );
}
