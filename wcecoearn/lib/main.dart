import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

String globalPhoneNumber = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ddbeljhytzkesrghkfao.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRkYmVsamh5dHprZXNyZ2hrZmFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE4NjgwOTgsImV4cCI6MjA1NzQ0NDA5OH0.Wcj4qvHf1GRSKa6ltG8jctR4Bkb8oRHPqTi6Wg3rmnw',
  );

  // Check login state
  final prefs = await SharedPreferences.getInstance();
  final phoneNo = prefs.getString('phone_no');

  if (phoneNo != null) {
    globalPhoneNumber = phoneNo; // Set the global phone number
    runApp(HomeApp()); // Navigate to HomePage
  } else {
    runApp(LoginApp()); // Navigate to LoginPage
  }
}

// Get a reference to your Supabase client
final supabase = Supabase.instance.client;

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoEarn',
      home: LoginPage(),
    );
  }
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoEarn',
      home: HomePage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  String _phoneno = '';
  String _password = '';

  Future<void> _login() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      try {
        // Retrieve the password from Supabase
        final response = await supabase
            .from('wCollector')
            .select('password, name')
            .eq('phone_no', _phoneno.toString())
            .maybeSingle(); // Use maybeSingle to handle null responses

        if (response == null) {
          // No matching record found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No Data Found',
                style: TextStyle(color: Color(0xFFFDFFA9)),
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final wc_name = response['name'].toString().trim();
        final storedPassword = response['password'].toString().trim();

        if (storedPassword == _password.trim()) {
          globalPhoneNumber = _phoneno; // Store the phone number globally

          // Save login state to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('phone_no', _phoneno);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Welcome Back $wc_name',
                style: TextStyle(color: Color(0xFFFDFFA9)),
              ),
              backgroundColor: Color(0xFF019267),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invalid password.',
                style: TextStyle(color: Color(0xFFFDFFA9)),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: TextStyle(color: Color(0xFFFDFFA9)),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECE852), // Updated background color
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                style:
                    TextStyle(color: Color(0xFF5CB338)), // Updated text color
                decoration: InputDecoration(
                  labelText: 'Phone No',
                  labelStyle: TextStyle(
                      color: Color(0xFF5CB338)), // Updated label color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF5CB338)), // Updated border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF5CB338),
                        width: 2), // Updated border color
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneno = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                style:
                    TextStyle(color: Color(0xFF5CB338)), // Updated text color
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      color: Color(0xFF5CB338)), // Updated label color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF5CB338)), // Updated border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF5CB338),
                        width: 2), // Updated border color
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFB4141), // Updated button color
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Login',
                  style:
                      TextStyle(color: Color(0xFF5CB338)), // Updated text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
