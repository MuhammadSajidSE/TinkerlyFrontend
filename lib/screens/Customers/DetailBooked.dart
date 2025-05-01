import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/reusable_components/constants.dart';
import 'package:tinkerly/reusable_components/widgets.dart';

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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Booking Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: widget.workerAvatarId.isNotEmpty
//                       ? NetworkImage("http://150.136.5.153:2280/cdn/${widget.workerAvatarId}.png")
//                       : null,
//                   child: widget.workerAvatarId.isEmpty
//                       ? const Icon(Icons.person, size: 50)
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text('Worker Name: ${widget.workerName}', style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 10),
//               Text('Address: ${widget.workerAddress}', style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 10),
//               Text('Work: ${widget.workName}', style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 10),
//               Text('Price: Rs. ${widget.workPrice}', style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 10),
//               Text('Experience: ${widget.yearsOfExperience} years', style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 10),
//               Text('Education: ${widget.workerEducation}', style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 10),
//               Text('Start Date: ${widget.startDate}', style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 10),
//               Text('End Date: ${widget.endDate}', style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 10),
//               Text('Description: ${widget.description}', style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 30),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _showCompleteDialog,
//                   child: const Text('Complete'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.backgroundColor,
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      title: const Text(
        'Booking Details',
        style: TextStyle(
            color: AppColors.primaryColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    body: Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Image.asset(
            'assets/images/design.png',
            width: 136,
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
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
                const SizedBox(height: 10),
                Text(
                  widget.workerName,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRow(Icons.location_on, "Address", widget.workerAddress),
                      buildRow(Icons.work, "Work", widget.workName),
                      buildRow(Icons.attach_money, "Price", "Rs. ${widget.workPrice}"),
                      buildRow(Icons.work_history, "Experience", "${widget.yearsOfExperience} years"),
                      buildRow(Icons.school, "Education", widget.workerEducation),
                      buildRow(Icons.date_range, "Start Date", widget.startDate),
                      buildRow(Icons.event, "End Date", widget.endDate),
                      buildRow(Icons.description, "Description", widget.description),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LoginRegisterButton(
                  onPressed: _showCompleteDialog,
                  text: 'Complete'
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.amber),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: AppColors.primaryColor),
              children: [
                TextSpan(
                    text: '$label ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: ': ', style: TextStyle(color: Colors.amber)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}