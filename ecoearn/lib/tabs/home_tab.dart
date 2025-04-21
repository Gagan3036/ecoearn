import 'package:flutter/material.dart';
import 'package:ecoearn/main.dart'; // Import main.dart to access globalPhoneNumber
import 'package:ecoearn/globals.dart'; // Import globals.dart to access global variables

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<dynamic> bookings = []; // List to store bookings data
  bool isLoading = true; // To show loading indicator

  String customerName = globalCustomerName;
  String customerEmail = globalCustomerEmail;
  String customerPincode = globalCustomerPincode;
  String customerAddress = globalCustomerAddress;

  @override
  void initState() {
    super.initState();
    if (customerName == 'Loading...' || customerAddress == 'Loading...') {
      _fetchCustomerData();
      _fetchCustomerAddress();
    }
    _fetchBookings(); // Fetch bookings on initialization
  }

  Future<void> _fetchCustomerData() async {
    try {
      final response = await supabase
          .from('customers')
          .select('cus_name, mail_id')
          .eq('phone_no', globalPhoneNumber)
          .maybeSingle();

      if (response != null) {
        setState(() {
          customerName = response['cus_name'] ?? 'Customer';
          customerEmail = response['mail_id'] ?? '';
          globalCustomerName = customerName; // Update global variable
          globalCustomerEmail = customerEmail; // Update global variable
        });
      } else {
        setState(() {
          customerName = 'Customer';
          customerEmail = '';
          globalCustomerName = customerName; // Update global variable
          globalCustomerEmail = customerEmail; // Update global variable
        });
      }
    } catch (e) {
      setState(() {
        customerName = 'Error fetching data';
        customerEmail = 'Please try again later';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchCustomerAddress() async {
    try {
      final addressResponse = await supabase
          .from('address')
          .select('pincode, address')
          .eq('phone_no', globalPhoneNumber)
          .maybeSingle();

      if (addressResponse != null) {
        setState(() {
          customerPincode = addressResponse['pincode']?.toString() ?? 'Null';
          customerAddress = addressResponse['address'] ?? 'Null';
          globalCustomerPincode = customerPincode; // Update global variable
          globalCustomerAddress = customerAddress; // Update global variable
        });
      } else {
        setState(() {
          customerPincode = 'Null';
          customerAddress = 'Null';
          globalCustomerPincode = customerPincode; // Update global variable
          globalCustomerAddress = customerAddress; // Update global variable
        });
      }
    } catch (e) {
      setState(() {
        customerPincode = 'N/A';
        customerAddress = 'N/A';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchBookings() async {
    try {
      final response = await supabase
          .from('bookings')
          .select()
          .eq('cus_phone_no', globalPhoneNumber);

      setState(() {
        bookings = response; // Store fetched bookings
        isLoading = false; // Stop loading indicator
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching bookings: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchCustomerData();
        await _fetchCustomerAddress();
        await _fetchBookings();
      },
      color: Colors.white,
      backgroundColor: Color(0xFF019267),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Details Card
                  _buildCustomerCard(),

                  // Booking Cards
                  bookings.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'No bookings found.',
                              style:
                                  TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: bookings.length,
                          itemBuilder: (context, index) {
                            return _buildBookingCard(bookings[index]);
                          },
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildCustomerCard() {
    return SizedBox(
      width: double.infinity,
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
                    customerName,
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
                  Icon(Icons.email, color: Color(0xFF019267)),
                  SizedBox(width: 8.0),
                  Text(
                    customerEmail,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.location_on, color: Color(0xFF019267)),
                  SizedBox(width: 8.0),
                  Text(
                    customerAddress,
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
                    customerPincode,
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

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final itemImageLink = booking['item_image_link'];
    final itemCategory = booking['item_category'];
    final startDate = booking['start_date'];
    final endDate = booking['end_date'];
    final time = booking['time'];
    final status = booking['status'];
    final assignedWcPhoneNo = booking['assigned_wc_phone_no'];

    // Format date
    final displayDate = startDate == endDate
        ? startDate
        : '$startDate to $endDate'; // Show single date or range

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2.0, // Reduce elevation for smaller shadow
      child: Padding(
        padding: EdgeInsets.all(8.0), // Reduce padding for smaller card
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (itemImageLink != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  itemImageLink,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(width: 8.0),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    'Category: $itemCategory',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),

                  // Date and Time
                  Text(
                    'Date: $displayDate',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  Text(
                    'Time: $time',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  SizedBox(height: 4.0),

                  // Status
                  Row(
                    children: [
                      Icon(
                        status == 'accepted'
                            ? Icons.check_circle
                            : Icons.warning,
                        color:
                            status == 'accepted' ? Colors.green : Colors.yellow,
                        size: 16.0,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        status == 'accepted' ? 'Accepted' : 'Pending',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: status == 'accepted'
                              ? Colors.green
                              : Colors.yellow,
                        ),
                      ),
                    ],
                  ),

                  // Assigned Waste Collector (if accepted)
                  if (status == 'accepted' && assignedWcPhoneNo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Collector: $assignedWcPhoneNo',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
