import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';
import 'tabs/AvilabeworkTab.dart';
import 'tabs/AnalyticsTab.dart';
import 'tabs/CashoutTab.dart';
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
    AvilabeworkTab(), // Navigate to the ReportTab
    AnalyticsTab(), // Navigate to the EarningsTab
    CashoutTab(), // Navigate to the DonatePage
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
        title: Text('Waste Collector'),
        backgroundColor: Color(0xFF5CB338), // Updated AppBar color
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
        selectedItemColor: Color(0xFF5CB338), // Updated selected tab color
        unselectedItemColor: Color(0xFFFFC145), // Updated unselected tab color
        backgroundColor: Color(0xFFECE852), // Updated background color
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Available Work',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Cashout',
          ),
        ],
      ),
    );
  }
}
