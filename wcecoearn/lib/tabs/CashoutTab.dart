import 'package:flutter/material.dart';
import '../main.dart';

class CashoutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Donate Page!',
              style: TextStyle(fontSize: 24, color: Color(0xFF019267)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Your phone number: $globalPhoneNumber',
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
