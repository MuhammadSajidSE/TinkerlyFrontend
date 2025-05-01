import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:tinkerly/providers/userprovider.dart';

class DetailBooked extends StatefulWidget {
  final String bookingId;
  final String workName;
  final String workPrice;
  final String workerAvatarId;
  final String workerName;
  final String workerAddress;
  final String yearsOfExperience;
  final String workerEducation;
  final String startDate;
  final String endDate;
  final String description;

  const DetailBooked({
    Key? key,
    required this.bookingId,
    required this.workName,
    required this.workPrice,
    required this.workerAvatarId,
    required this.workerName,
    required this.workerAddress,
    required this.yearsOfExperience,
    required this.workerEducation,
    required this.startDate,
    required this.endDate,
    required this.description,
  }) : super(key: key);

  @override
  State<DetailBooked> createState() => _DetailBookedState();
}

class _DetailBookedState extends State<DetailBooked> {
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _submitFeedback(bool isReported) async {
          final user = Provider.of<UserProvider>(context, listen: false).user;
      final token = user!.token;

    const String url = "http://150.136.5.153:2279/work/complete";
    // const String token = "your_auth_token_here"; // <-- Replace this with your actual token

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "bookingId": widget.bookingId,
          "isReported": isReported,
          "review": _feedbackController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context); // Close the popup
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit feedback.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Complete Booking'),
          content: TextField(
            controller: _feedbackController,
            decoration: const InputDecoration(
              hintText: 'Enter your feedback...',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => _submitFeedback(true), // Report
              child: const Text('Report', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () => _submitFeedback(false), // Normal submit
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.workerAvatarId.isNotEmpty
                      ? NetworkImage("http://150.136.5.153:2280/cdn/${widget.workerAvatarId}.png")
                      : null,
                  child: widget.workerAvatarId.isEmpty
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text('Worker Name: ${widget.workerName}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Address: ${widget.workerAddress}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Work: ${widget.workName}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Price: Rs. ${widget.workPrice}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Experience: ${widget.yearsOfExperience} years', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Education: ${widget.workerEducation}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Start Date: ${widget.startDate}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('End Date: ${widget.endDate}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Description: ${widget.description}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _showCompleteDialog,
                  child: const Text('Complete'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
