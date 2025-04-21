import 'package:flutter/material.dart';
import 'package:wcecoearn/main.dart'; // Import main.dart to access globalPhoneNumber
import 'package:wcecoearn/globals.dart'; // Import globals.dart to access global variables

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  String wcName = globalWcName;
  String wcPincode = globalWcPincode;
  List<dynamic> assignedWorks = []; // List to store assigned works

  @override
  bool get wantKeepAlive => false; // Ensures data refresh on tab switch

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
    _fetchAssignedWorks();
  }

  Future<void> _fetchCustomerData() async {
    try {
      final response = await supabase
          .from('wCollector')
          .select('name, pincode')
          .eq('phone_no', globalPhoneNumber)
          .maybeSingle();

      if (response != null) {
        setState(() {
          wcName = response['name'] ?? 'WC';
          wcPincode = response['pincode']?.toString() ?? '';
          globalWcName = wcName; // Update global variable
          globalWcPincode = wcPincode; // Update global variable
        });
      } else {
        setState(() {
          wcName = 'Customer';
          wcPincode = '';
          globalWcName = wcName; // Update global variable
          globalWcPincode = wcPincode; // Update global variable
        });
      }
    } catch (e) {
      setState(() {
        wcName = 'Error fetching data';
        wcPincode = 'Please try again later';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchAssignedWorks() async {
    try {
      final response = await supabase
          .from('bookings')
          .select()
          .eq('assigned_wc_phone_no', globalPhoneNumber);

      setState(() {
        assignedWorks = response;
      });
    } catch (e) {
      print('Error fetching assigned works: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching works: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildCustomerCard() {
    return SizedBox(
      width: double.infinity,
      height: 154.0,
      child: Card(
        margin: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        elevation: 4.0, // Add shadow to the card
        child: Padding(
          padding: EdgeInsets.all(16.0), // Add padding inside the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Color(0xFF019267)),
                  SizedBox(width: 8.0),
                  Text(
                    wcName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.phone, color: Color(0xFF019267)),
                  SizedBox(width: 8.0),
                  Text(
                    '+91 $globalPhoneNumber',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.pin_drop, color: Color(0xFF019267)),
                  SizedBox(width: 8.0),
                  Text(
                    globalWcPincode,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorksList() {
    if (assignedWorks.isEmpty) {
      return Center(
        child: Text(
          'No assigned works',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: assignedWorks.length,
      itemBuilder: (context, index) {
        final work = assignedWorks[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkDetailsScreen(work: work),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  work['item_image_link'] != null
                      ? Image.network(
                          work['item_image_link'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 50),
                        )
                      : Icon(Icons.image_not_supported, size: 50),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category: ${work['item_category']}',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Date: ${work['start_date']} - ${work['end_date']}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Text(
                          'Time: ${work['time']}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchCustomerData();
        await _fetchAssignedWorks(); // Refresh works data
      },
      color: Colors.white,
      backgroundColor: Color(0xFF019267),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildCustomerCard(),
            SizedBox(height: 5.0),
            Center(
              child: Text(
                'Accepted Works',
                style: TextStyle(fontSize: 16, color: Color(0xFF019267)),
                textAlign: TextAlign.left,
              ),
            ),
            _buildWorksList(), // Add the works list here
          ],
        ),
      ),
    );
  }
}

class WorkDetailsScreen extends StatelessWidget {
  final dynamic work;

  const WorkDetailsScreen({Key? key, required this.work}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            work['item_image_link'] != null
                ? Image.network(
                    work['item_image_link'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 50),
                  )
                : Icon(Icons.image_not_supported, size: 50),
            SizedBox(height: 16.0),
            Text(
              'Category: ${work['item_category']}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Description: ${work['description']}'),
            SizedBox(height: 8.0),
            Text('Date: ${work['start_date']} - ${work['end_date']}'),
            Text('Time: ${work['time']}'),
            SizedBox(height: 8.0),
            Text('Address: ${work['cus_address']}'),
            Text('Pincode: ${work['cus_pincode']}'),
            Text('Customer Phone: ${work['cus_phone_no']}'),
          ],
        ),
      ),
    );
  }
}
