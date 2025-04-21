import 'package:flutter/material.dart';
import 'package:ecoearn/globals.dart'; // Import globals.dart for global variables
import 'package:ecoearn/main.dart'; // Import main.dart for Supabase instance
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For File handling
import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:image/image.dart' as img; // Import the image package
import 'package:path_provider/path_provider.dart'; // For accessing temporary directory

class DonateTab extends StatefulWidget {
  const DonateTab({super.key});

  @override
  _DonateTabState createState() => _DonateTabState();
}

class _DonateTabState extends State<DonateTab> {
  final _formKey = GlobalKey<FormState>();
  File? _wasteImage;
  String? _wasteCategory;
  String? _description; // Added description field
  bool _isContinuous = false;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _collectionTime;
  bool _isLoading = false; // To track loading state

  // Function to pick an image (from camera or gallery)
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();

      // Show options to choose between camera and gallery
      await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Color(0xFF5CB338)),
                  title: Text('Take Photo'),
                  onTap: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _wasteImage =
                            File(pickedFile.path); // Directly set the image
                      });
                    }
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Color(0xFF5CB338)),
                  title: Text('Choose from Gallery'),
                  onTap: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _wasteImage =
                            File(pickedFile.path); // Directly set the image
                      });
                    }
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<File> _compressImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final decodedImage = img.decodeImage(bytes);

      if (decodedImage != null) {
        final compressedImage = img.encodeJpg(decodedImage,
            quality: 70); // Compress with 70% quality
        final tempDir = await getTemporaryDirectory();
        final compressedFile = File('${tempDir.path}/compressed_image.jpg');
        await compressedFile.writeAsBytes(compressedImage);
        return compressedFile;
      } else {
        throw Exception(
            'Failed to decode image. The file may be corrupted or unsupported.');
      }
    } catch (e) {
      throw Exception('Error compressing image: $e');
    }
  }

  // Function to insert data into Supabase
  Future<void> _submitData() async {
    if (_formKey.currentState!.validate() && _wasteImage != null) {
      final startDate = _startDate?.toIso8601String() ?? '';
      final endDate =
          _isContinuous ? _endDate?.toIso8601String() ?? '' : startDate;
      final time = _collectionTime != null
          ? '${_collectionTime!.hour}:${_collectionTime!.minute}'
          : '';

      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Prepare the request
        final uri = Uri.parse('https://ecoearnapi.vercel.app/booking');
        final request = http.MultipartRequest('POST', uri);

        // Add form-data fields (matching new API keys)
        request.fields['cus_phone_no'] =
            globalPhoneNumber; // e.g., "1234567890"
        request.fields['item_category'] =
            _wasteCategory!; // e.g., "Electronics"
        request.fields['start_date'] = startDate; // e.g., "2025-04-01"
        request.fields['end_date'] = endDate; // e.g., "2025-04-05"
        request.fields['time'] = time; // e.g., "10:00 AM"
        request.fields['cus_pincode'] = globalCustomerPincode; // e.g., "123456"
        request.fields['cus_address'] =
            globalCustomerAddress; // e.g., "123 Main St"
        request.fields['description'] =
            _description ?? ''; // e.g., "Repair required"

        // Add the image file
        request.files.add(
          await http.MultipartFile.fromPath('file', _wasteImage!.path),
        );

        // Send the request
        final response = await request.send();

        // Clear the fields and stop loading
        setState(() {
          _wasteImage = null;
          _wasteCategory = null;
          _description = null;
          _isContinuous = false;
          _startDate = null;
          _endDate = null;
          _collectionTime = null;
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseBody);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking submitted successfully!')),
          );

          _formKey.currentState!.reset();
        } else {
          throw Exception(
              'Failed to submit booking. Status code: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting booking: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please fill all required fields and upload an image.')),
      );
    }
  }

  // Function to pick a date
  Future<void> _pickDate({required bool isStartDate}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          if (!_isContinuous) {
            _endDate = pickedDate; // For single-time collection, start = end
          }
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  // Function to pick a time
  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _collectionTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upload Waste Photo
                  Text('Upload Waste Photo', style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF5CB338)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: _wasteImage == null
                          ? Center(child: Text('Tap to click or upload image'))
                          : Image.file(_wasteImage!, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Select Waste Category
                  Text('Select Waste Category',
                      style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: _wasteCategory,
                    items:
                        ['Plastic', 'Metal', 'Organic', 'Electronic', 'Other']
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ))
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _wasteCategory = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select a category',
                    ),
                    validator: (value) =>
                        value == null ? 'Please select a waste category' : null,
                  ),
                  SizedBox(height: 16.0),

                  // Description Field
                  Text('Description', style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a description...',
                    ),
                    onChanged: (value) {
                      _description = value;
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a description'
                        : null,
                  ),
                  SizedBox(height: 16.0),

                  // Continuous or Single-Time Collection
                  Row(
                    children: [
                      Checkbox(
                        value: _isContinuous,
                        onChanged: (value) {
                          setState(() {
                            _isContinuous = value!;
                            if (!_isContinuous) {
                              _endDate =
                                  _startDate; // Reset end date for single-time
                            }
                          });
                        },
                      ),
                      Text('Continuous Waste Collection'),
                    ],
                  ),
                  SizedBox(height: 8.0),

                  // Date and Time Selection
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _pickDate(isStartDate: true),
                          child: Text(
                            _startDate == null
                                ? 'Select Start Date'
                                : 'Start: ${_startDate!.toLocal().toString().split(' ')[0]}', // Format date
                          ),
                        ),
                      ),
                      if (_isContinuous) SizedBox(width: 8.0),
                      if (_isContinuous)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _pickDate(isStartDate: false),
                            child: Text(
                              _endDate == null
                                  ? 'Select End Date'
                                  : 'End: ${_endDate!.toLocal().toString().split(' ')[0]}', // Format date
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: _pickTime,
                    child: Text(_collectionTime == null
                        ? 'Select Collection Time'
                        : 'Time: ${_collectionTime!.format(context)}'),
                  ),
                  SizedBox(height: 16.0),

                  // Auto-filled Customer Details
                  Text('Customer Details', style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  Text('Name: $globalCustomerName'),
                  Text('Phone: $globalPhoneNumber'),
                  Text('Pincode: $globalCustomerPincode'),
                  Text('Address: $globalCustomerAddress'),
                  SizedBox(height: 16.0),

                  // Submit Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFF5CB338), // Submit button color
                      ),
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF5CB338)),
            ),
          ),
      ],
    );
  }
}
