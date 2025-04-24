// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tinkerly/providers/userprovider.dart';
// import 'package:http/http.dart' as http;

// class SkillDetailScreen extends StatefulWidget {
//   final String skillId;

//   const SkillDetailScreen({super.key, required this.skillId});

//   @override
//   State<SkillDetailScreen> createState() => _SkillDetailScreenState();
// }

// class _SkillDetailScreenState extends State<SkillDetailScreen> {
//   List<Map<String, dynamic>> matchedWorkers = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchWorkers();
//   }

//   Future<void> fetchWorkers() async {
//     final user = Provider.of<UserProvider>(context, listen: false).user;
//     final token = user?.token;

//     final url = Uri.parse('http://150.136.5.153:2279/workers');

//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);

//         final data = jsonResponse['data'] as List;
//         final allWorkers = data.expand((group) => group).toList();

//         final filtered = allWorkers.where((worker) {
//           final skills = List<String>.from(worker['workerProfile']['workerSkills']);
//           return skills.contains(widget.skillId);
//         }).map((e) => Map<String, dynamic>.from(e)).toList();

//         setState(() {
//           matchedWorkers = filtered;
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load workers');
//       }
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Skill Detail')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : matchedWorkers.isEmpty
//               ? const Center(child: Text('No workers found with this skill.'))
//               : ListView.builder(
//                   itemCount: matchedWorkers.length,
//                   itemBuilder: (context, index) {
//                     final worker = matchedWorkers[index];
//                     final userDetails = worker['userDetails'];
//                     final profile = worker['workerProfile'];

//                     return Card(
//                       margin: const EdgeInsets.all(8.0),
//                       child: ListTile(
//                         title: Text(userDetails['name'] ?? 'No Name'),
//                         subtitle: Text('Experience: ${profile['yearsOfExperience']} years\n'
//                             'Rating: ${worker['averageRating']}'),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/screens/Customers/BookingScreen.dart';

class SkillDetailScreen extends StatefulWidget {
  final String skillId;

  const SkillDetailScreen({super.key, required this.skillId});

  @override
  State<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends State<SkillDetailScreen> {
  List<Map<String, dynamic>> matchedWorkers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkers();
  }

  Future<void> fetchWorkers() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final token = user?.token;

    final url = Uri.parse('http://150.136.5.153:2279/workers');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        final data = jsonResponse['data'] as List;
        final allWorkers = data.expand((group) => group).toList();

        final filtered = allWorkers.where((worker) {
          final skills = List<String>.from(worker['workerProfile']['workerSkills']);
          return skills.contains(widget.skillId);
        }).map((e) => Map<String, dynamic>.from(e)).toList();

        setState(() {
          matchedWorkers = filtered;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load workers');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToBookingScreen(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill Detail')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : matchedWorkers.isEmpty
              ? const Center(child: Text('No workers found with this skill.'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: matchedWorkers.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final worker = matchedWorkers[index];
                      final userDetails = worker['userDetails'];
                      final profile = worker['workerProfile'];

                      return GestureDetector(
                        onTap: () => navigateToBookingScreen(worker['userId']),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person, size: 60, color: Colors.blueGrey),
                                const SizedBox(height: 10),
                                Text(
                                  userDetails['name'] ?? 'No Name',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text('⭐ ${worker['averageRating']}', style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 5),
                                Text(
                                  userDetails['address'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Exp: ${profile['yearsOfExperience']} yrs',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
