import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wcecoearn/main.dart';
import 'package:wcecoearn/globals.dart';

class AvilabeworkTab extends StatefulWidget {
  @override
  _AvilabeworkTabState createState() => _AvilabeworkTabState();
}

class _AvilabeworkTabState extends State<AvilabeworkTab> {
  final supabase = Supabase.instance.client;
  List<dynamic> availableWorks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAvailableWorks();
  }

  Future<void> fetchAvailableWorks() async {
    try {
      final response = await supabase
          .from('bookings')
          .select()
          .eq('cus_pincode', globalWcPincode)
          .eq('status', 'pending'); // Fetch only pending works

      setState(() {
        availableWorks = response;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> acceptWork(int id) async {
    try {
      await supabase.from('bookings').update({
        'assigned_wc_phone_no': globalPhoneNumber,
        'status': 'accepted' // Update status to accepted
      }).eq('id', id);

      // Refresh the list after accepting work
      fetchAvailableWorks();
    } catch (error) {
      print('Error updating data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : availableWorks.isEmpty
            ? Center(
                child: Text(
                  'No available work',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: availableWorks.length,
                itemBuilder: (context, index) {
                  final work = availableWorks[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: work['item_image_link'] != null
                          ? Image.network(
                              work['item_image_link'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image, size: 50),
                            )
                          : Icon(Icons.image_not_supported, size: 50),
                      title: Text('Work ID: ${work['id']}'),
                      subtitle:
                          Text('Customer Pincode: ${work['cus_pincode']}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkDetailsScreen(work: work),
                          ),
                        );
                      },
                      trailing: ElevatedButton(
                        onPressed: () => acceptWork(work['id']),
                        child: Text('Accept'),
                      ),
                    ),
                  );
                },
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
