// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:tinkerly/providers/userprovider.dart';

// class BookingScreen extends StatefulWidget {
//   final String userId;

//   const BookingScreen({super.key, required this.userId});

//   @override
//   State<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   Map<String, dynamic>? workerData;
//   bool isLoading = true;
//   final Map<int, String> domainNames = {
//     0: 'Carpentry',
//     1: 'Electrical',
//     2: 'Plumbing',
//     3: 'Masonry',
//     4: 'Welding',
//   };

//   Map<String, String> skillMap = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchWorkerDetails();
//   }

//   Future<void> fetchWorkerDetails() async {
//     final user = Provider.of<UserProvider>(context, listen: false).user;
//     final token = user?.token;

//     try {
//       final workerResponse = await http.get(
//         Uri.parse('http://150.136.5.153:2279/worker/${widget.userId}'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       final skillsResponse = await http.get(
//         Uri.parse('http://150.136.5.153:2279/work/details'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (workerResponse.statusCode == 200 && skillsResponse.statusCode == 200) {
//         final workerJson = jsonDecode(workerResponse.body);
//         final skillJson = jsonDecode(skillsResponse.body);

//         final skillData = skillJson['data'] as List;
//         for (var skill in skillData) {
//           skillMap[skill['id']] = skill['type'];
//         }

//         setState(() {
//           workerData = workerJson['data'];
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Widget buildProfileImage(String? avatarId) {
//     if (avatarId == null) {
//       return const CircleAvatar(
//         radius: 60,
//         child: Icon(Icons.person, size: 60),
//       );
//     } else {
//       final imageUrl = 'http://150.136.5.153:2280/cdn/$avatarId.png';
//       return CircleAvatar(
//         radius: 60,
//         backgroundImage: NetworkImage(imageUrl),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Booking')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : workerData == null
//               ? const Center(child: Text('Failed to load worker details.'))
//               : Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ListView(
//                     children: [
//                       Center(child: buildProfileImage(workerData!['avatarId'])),
//                       const SizedBox(height: 16),
//                       Text(
//                         workerData!['userDetails']['name'],
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       Text('Email: ${workerData!['userDetails']['email']}'),
//                       Text('Phone: ${workerData!['userDetails']['phone']}'),
//                       Text('NIC: ${workerData!['userDetails']['nic']}'),
//                       Text('Age: ${workerData!['userDetails']['age']}'),
//                       Text('Address: ${workerData!['userDetails']['address']}'),
//                       const SizedBox(height: 10),
//                       Text('Rating: ${workerData!['averageRating']}'),
//                       Text('Experience: ${workerData!['workerProfile']['yearsOfExperience']} years'),
//                       const SizedBox(height: 10),
//                       const Text('Education:', style: TextStyle(fontWeight: FontWeight.bold)),
//                       ...List<String>.from(workerData!['workerProfile']['workerEducation']).map(
//                         (edu) => Text('- $edu'),
//                       ),
//                       const SizedBox(height: 10),
//                       const Text('Domains:', style: TextStyle(fontWeight: FontWeight.bold)),
//                       ...List<int>.from(workerData!['workerProfile']['workerDomains']).map(
//                         (domain) => Text('- ${domainNames[domain] ?? "Unknown"}'),
//                       ),
//                       const SizedBox(height: 10),
//                       const Text('Skills:', style: TextStyle(fontWeight: FontWeight.bold)),
//                       ...List<String>.from(workerData!['workerProfile']['workerSkills']).map(
//                         (skillId) => Text('- ${skillMap[skillId] ?? "Unknown Skill"}'),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tinkerly/providers/userprovider.dart';

class BookingScreen extends StatefulWidget {
  final String userId;

  const BookingScreen({super.key, required this.userId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Map<String, dynamic>? workerData;
  bool isLoading = true;
  bool isSubmitting = false;
  final TextEditingController _descriptionController = TextEditingController();

  final Map<int, String> domainNames = {
    0: 'Carpentry',
    1: 'Electrical',
    2: 'Plumbing',
    3: 'Masonry',
    4: 'Welding',
  };

  Map<String, String> skillMap = {};

  @override
  void initState() {
    super.initState();
    fetchWorkerDetails();
  }

  Future<void> fetchWorkerDetails() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final token = user?.token;

    try {
      final workerResponse = await http.get(
        Uri.parse('http://150.136.5.153:2279/worker/${widget.userId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final skillsResponse = await http.get(
        Uri.parse('http://150.136.5.153:2279/work/details'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (workerResponse.statusCode == 200 &&
          skillsResponse.statusCode == 200) {
        final workerJson = jsonDecode(workerResponse.body);
        final skillJson = jsonDecode(skillsResponse.body);

        final skillData = skillJson['data'] as List;
        for (var skill in skillData) {
          skillMap[skill['id']] = skill['type'];
        }

        setState(() {
          workerData = workerJson['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildProfileImage(String? avatarId) {
    if (avatarId == null) {
      return const CircleAvatar(
        radius: 60,
        child: Icon(Icons.person, size: 60),
      );
    } else {
      final imageUrl = 'http://150.136.5.153:2280/cdn/$avatarId.png';
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(imageUrl),
      );
    }
  }

  void _showHiringDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Work Description"),
          content: TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: "Describe the work..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: isSubmitting ? null : _submitHiringRequest,
              child: isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitHiringRequest() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final token = user?.token;
    final customerId = user?.userId;

    if (token == null || customerId == null) return;

    setState(() {
      isSubmitting = true;
    });

    final skillIds =
        List<String>.from(workerData!['workerProfile']['workerSkills']);
    final workDetailsId = skillIds.isNotEmpty ? skillIds.first : "";

    final body = {
      "requestId": null,
      "customerId": customerId,
      "workerId": widget.userId,
      "workDetailsId": workDetailsId,
      "description": _descriptionController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('http://150.136.5.153:2279/work/create/request'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request submitted successfully!')),
        );
        _descriptionController.clear();
      } else {
        throw Exception('Failed to submit request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : workerData == null
              ? const Center(child: Text('Failed to load worker details.'))
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          children: [
                            Center(
                                child: buildProfileImage(
                                    workerData!['avatarId'])),
                            const SizedBox(height: 16),
                            Text(
                              workerData!['userDetails']['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                                'Email: ${workerData!['userDetails']['email']}'),
                            Text(
                                'Phone: ${workerData!['userDetails']['phone']}'),
                            Text('NIC: ${workerData!['userDetails']['nic']}'),
                            Text('Age: ${workerData!['userDetails']['age']}'),
                            Text(
                                'Address: ${workerData!['userDetails']['address']}'),
                            const SizedBox(height: 10),
                            Text(
                                'Rating: ${workerData!['averageRating'].toString()}'),
                            Text(
                                'Experience: ${workerData!['workerProfile']['yearsOfExperience']} years'),
                            const SizedBox(height: 10),
                            const Text('Education:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            ...List<String>.from(workerData!['workerProfile']
                                    ['workerEducation'])
                                .map((edu) => Text('- $edu')),
                            const SizedBox(height: 10),
                            const Text('Domains:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            ...List<int>.from(workerData!['workerProfile']
                                    ['workerDomains'])
                                .map((domain) => Text(
                                    '- ${domainNames[domain] ?? "Unknown"}')),
                            const SizedBox(height: 10),
                            const Text('Skills:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            ...List<String>.from(workerData!['workerProfile']
                                    ['workerSkills'])
                                .map((skillId) => Text(
                                    '- ${skillMap[skillId] ?? "Unknown Skill"}')),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _showHiringDialog();
                          },
                          child: const Text("Hiring"),
                        ),
                      ),
                    )
                  ],
                ),
    );
  }
}
