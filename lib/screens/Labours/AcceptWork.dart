import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';
import 'package:tinkerly/providers/userprovider.dart';
// import 'user_provider.dart'; // Assuming you have a provider for user

class AcceptWork extends StatefulWidget {
  final String name;
  final String avatarId;
  final String address;
  final String phone;
  final String description;
  final String requestId;
  final String workDetailsId;

  const AcceptWork({
    required this.name,
    required this.avatarId,
    required this.address,
    required this.phone,
    required this.description,
    required this.requestId,
    required this.workDetailsId,
  });

  @override
  _AcceptWorkState createState() => _AcceptWorkState();
}

class _AcceptWorkState extends State<AcceptWork> {
  String? workName;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int cost = 0;

  @override
  void initState() {
    super.initState();
    _fetchWorkName();
  }

  Future<void> _fetchWorkName() async {
    final response = await http.get(Uri.parse('http://150.136.5.153:2279/work/details'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (!data['errored']) {
        List workDetails = data['data'];
        for (var work in workDetails) {
          if (work['id'] == widget.workDetailsId) {
            setState(() {
              workName = work['type'];
            });
            break;
          }
        }
      } else {
        // Handle error if needed
        print('Error fetching data: ${data['errorMessage']}');
      }
    } else {
      // Handle HTTP error if needed
      print('Failed to load work details');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  Future<void> _submitData() async {
    if (selectedDate == null || startTime == null || endTime == null || cost <= 0) {
      // Show an error if required fields are missing
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please fill all fields correctly."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final user = Provider.of<UserProvider>(context, listen: false).user;
    String usertoken = user!.token;

    final startDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      startTime!.hour,
      startTime!.minute,
    ).toIso8601String();

    final endDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      endTime!.hour,
      endTime!.minute,
    ).toIso8601String();

    final response = await http.post(
      Uri.parse('http://150.136.5.153:2279/work/create/response'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $usertoken',
      },
      body: json.encode({
        'workRequestId': widget.requestId,
        'startDate': startDate,
        'endDate': endDate,
        'cost': cost,
        'status': 0,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success response
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Success"),
          content: Text("Work accepted successfully."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Handle failure response
      print('Failed to accept work');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accept Work'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular Image at the top
              Center(
                child: CircleAvatar(
                  radius: 50, // Adjust the size of the avatar
                  backgroundImage: NetworkImage('http://150.136.5.153:2280/cdn/${widget.avatarId}.png'),
                ),
              ),
              const SizedBox(height: 16), // Space between image and text
        
              // Display the work name if available
              if (workName != null)
                Text('Work Name: $workName', style: TextStyle(fontSize: 18)),
        
              const SizedBox(height: 16), // Space between work name and other details
              Text('Name: ${widget.name}', style: TextStyle(fontSize: 18)),
              Text('Address: ${widget.address}', style: TextStyle(fontSize: 18)),
              Text('Phone: ${widget.phone}', style: TextStyle(fontSize: 18)),
              Text('Description: ${widget.description}', style: TextStyle(fontSize: 18)),
              // Text('Request ID: ${widget.requestId}', style: TextStyle(fontSize: 18)),
              // Text('Work Details ID: ${widget.workDetailsId}', style: TextStyle(fontSize: 18)),
        
              const SizedBox(height: 16),
        
              // Date Picker
              Text('Select Date:', style: TextStyle(fontSize: 18)),
              ListTile(
                title: Text(selectedDate != null
                    ? DateFormat.yMd().format(selectedDate!)
                    : 'Select Date'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
        
              // Start Time Picker
              Text('Start Time:', style: TextStyle(fontSize: 18)),
              ListTile(
                title: Text(startTime != null ? startTime!.format(context) : 'Select Start Time'),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, true),
              ),
              const SizedBox(height: 16),
        
              // End Time Picker
              Text('End Time:', style: TextStyle(fontSize: 18)),
              ListTile(
                title: Text(endTime != null ? endTime!.format(context) : 'Select End Time'),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, false),
              ),
              const SizedBox(height: 16),
        
              // Cost Input
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Cost'),
                onChanged: (value) {
                  setState(() {
                    cost = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),
        
              // Confirm button
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
