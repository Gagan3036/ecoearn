import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';
import 'tabs/report_tab.dart';
import 'tabs/earnings_tab.dart';
import 'tabs/donate_tab.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Track the selected tab

  // List of pages for each tab
  final List<Widget> _pages = [
    HomeTab(), // Navigate to the HomeTab
    ReportTab(), // Navigate to the ReportTab
    EarningsTab(), // Navigate to the EarningsTab
    DonateTab(), // Navigate to the DonatePage
  ];

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('phone_no'); // Clear the saved phone number

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoEarn'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Highlight the selected tab
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab
          });
        },
        selectedItemColor: Color(0xFF019267), // Selected tab color
        unselectedItemColor: Colors.grey, // Unselected tab color
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_sharp),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num),
            label: 'Donate',
          ),
        ],
      ),
    );
  }
}
