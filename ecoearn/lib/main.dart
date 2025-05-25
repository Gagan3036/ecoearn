import 'package:flutter/material.dart';
import 'package:ecoearn/forgot_password.dart'; // <-- Add this
import 'package:ecoearn/login.dart';
import 'package:ecoearn/register.dart';

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
