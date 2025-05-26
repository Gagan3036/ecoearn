import 'package:flutter/material.dart';
import 'package:ecoearn/forgot_password.dart'; // <-- Add this
import 'package:ecoearn/login.dart';
import 'package:ecoearn/register.dart';
import 'package:ecoearn/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        'register': (context) => MyRegister(),
        'login': (context) => MyLogin(),
        'forgot': (context) => ForgotPassword(), // <-- Add this
      },
    ),
  );
}
