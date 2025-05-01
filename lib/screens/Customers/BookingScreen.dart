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
import 'package:tinkerly/reusable_components/constants.dart';
import 'package:tinkerly/reusable_components/widgets.dart';

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

  // Widget buildProfileImage(String? avatarId) {
  //   if (avatarId == null) {
  //     return const CircleAvatar(
  //       radius: 60,
  //       child: Icon(Icons.person, size: 60),
  //     );
  //   } else {
  //     final imageUrl = 'http://150.136.5.153:2280/cdn/$avatarId.png';
  //     return CircleAvatar(
  //       radius: 60,
  //       foregroundImage: avatarId == null
  //           ? null
  //           : NetworkImage('http://150.136.5.153:2280/cdn/$avatarId.png'),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           border: Border.all(
  //             color: Colors.blue, // Choose your border color
  //             width: 2.0, // Choose your border width
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  Widget buildProfileImage(String? avatarId) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 68,
        backgroundColor: AppColors.primaryColor,
        child: CircleAvatar(
          radius: 65,
          backgroundColor: AppColors.secondaryColor,
          child: CircleAvatar(
            radius: 62,
            // backgroundColor: AppColors.primaryColor,
            backgroundColor: Colors.amber,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: avatarId == null
                  ? null
                  : NetworkImage('http://150.136.5.153:2280/cdn/$avatarId.png'),
              child:
                  avatarId == null ? const Icon(Icons.person, size: 60) : null,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  // void _showHiringDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Enter Work Description"),
  //         content: TextField(
  //           controller: _descriptionController,
  //           maxLines: 3,
  //           decoration: const InputDecoration(hintText: "Describe the work..."),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: isSubmitting ? null : _submitHiringRequest,
  //             child: isSubmitting
  //                 ? const CircularProgressIndicator()
  //                 : const Text("Confirm"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
void _showHiringDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Enter Work Description",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Describe the work...",
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: AppColors.accentColor),
            ),
          ),
          LoginRegisterButton(
            // style: ElevatedButton.styleFrom(
            //   backgroundColor: AppColors.primaryColor,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            // ),
            onPressed: isSubmitting ? (){} : _submitHiringRequest,
            // child: isSubmitting
            //     ? const SizedBox(
            //         width: 20,
            //         height: 20,
            //         child: CircularProgressIndicator(
            //           color: Colors.white,
            //           strokeWidth: 2,
            //         ),
            //       )
            //     : const Text(
            text:  "Confirm",
            width: 130,
            // ),
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
          const SnackBar(content: Text('Request submitted successfully!',style: TextStyle(color: Colors.white),),
          backgroundColor: AppColors.primaryColor,
          duration: Duration(seconds: 2),
          
          ),
        );
        _descriptionController.clear();
      } else {
        throw Exception('Failed to submit request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'),
        backgroundColor: AppColors.primaryColor,
        duration: Duration(seconds: 2),
        ),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Booking',
          style: TextStyle(
              color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Your top-right big image
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/design.png',
              // height: 250, // make it big
              width: 136, // control width
              fit: BoxFit.contain,
            ),
          ),

          // Your main page content
          SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.only(top: 0), // Push down to avoid overlap
              child: isLoading
                  ? Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 100,
                    child: Center(child: CircularProgressIndicator())
                    )
                  : workerData == null
                      ? const Center(
                          child: Text('Failed to load worker details.'))
                      : Column(
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            // SizedBox(
                            //   height: 700,
                            // child:
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22.0),
                              child: Column(
                                children: [
                                  Center(
                                      child: buildProfileImage(
                                          workerData!['avatarId'])),
                                  Text(
                                    workerData!['userDetails']['name'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor),
                                  ),
                                  const SizedBox(height: 1),
                                  Container(
                                    padding: const EdgeInsets.all(18.0),
                                    width: double.infinity,
                                    height: 425,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryColor
                                              .withOpacity(1),
                                          spreadRadius: 2,
                                          blurRadius: 12,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.email,
                                                    color: Colors.amber),
                                                const SizedBox(width: 10),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Email '),
                                                      const TextSpan(
                                                        text: ':',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .amber), // Or your specific golden color
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              ' ${workerData!['userDetails']['email']}'),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.phone,
                                                    color: Colors.amber),
                                                const SizedBox(width: 10),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      const TextSpan(
                                                          text: 'Phone '),
                                                      const TextSpan(
                                                        text: ':',
                                                        style: TextStyle(
                                                            color: Colors.amber),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              ' ${workerData!['userDetails']['phone']}'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.perm_identity,
                                                    color: Colors
                                                        .amber), // You might want a different icon
                                                const SizedBox(width: 10),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      const TextSpan(
                                                          text: 'NIC '),
                                                      const TextSpan(
                                                        text: ':',
                                                        style: TextStyle(
                                                            color: Colors.amber),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              ' ${workerData!['userDetails']['nic']}'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.cake,
                                                    color: Colors
                                                        .amber), // You might want a different icon
                                                const SizedBox(width: 10),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      const TextSpan(
                                                          text: 'Age '),
                                                      const TextSpan(
                                                        text: ':',
                                                        style: TextStyle(
                                                            color: Colors.amber),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              ' ${workerData!['userDetails']['age']}'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start, // Align icon and text to the top
                                              children: [
                                                const Icon(Icons.location_on,
                                                    color: Colors.amber),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  // Use Expanded to allow text to wrap properly
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: <TextSpan>[
                                                        const TextSpan(
                                                            text: 'Address '),
                                                        const TextSpan(
                                                          text: ':',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.amber),
                                                        ),
                                                        TextSpan(
                                                            text:
                                                                ' ${workerData!['userDetails']['address']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    color: Colors.amber),
                                                const SizedBox(width: 10),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      const TextSpan(
                                                          text: 'Rating '),
                                                      const TextSpan(
                                                        text: ':',
                                                        style: TextStyle(
                                                            color: Colors.amber),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              ' ${workerData!['averageRating'].toString()}'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.work_history,
                                                    color: Colors.amber),
                                                const SizedBox(width: 10),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      const TextSpan(
                                                          text: 'Experience '),
                                                      const TextSpan(
                                                        text: ':',
                                                        style: TextStyle(
                                                            color: Colors.amber),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              '${workerData!['workerProfile']['yearsOfExperience']} years'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.school,
                                                    color: Colors.amber),
                                                const SizedBox(width: 10),
                                                const Text(
                                                  'Education:',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      color: AppColors
                                                          .primaryColor), // Adjust fontSize if needed
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                                height:
                                                    5), // Add some spacing between the heading and the list
                                            ...List<String>.from(
                                              workerData!['workerProfile']
                                                  ['workerEducation'],
                                            ).map((edu) => Padding(
                                                  // Add some padding for each education item
                                                  padding: const EdgeInsets.only(
                                                      left:
                                                          28.0), // Indent to align with text
                                                  child: Text(
                                                    '- $edu',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor),
                                                  ), // Adjust fontSize if needed
                                                )),
            // const SizedBox(height: 10),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.folder_open,
                                                    color: Colors
                                                        .amber), // Choose an appropriate icon
                                                const SizedBox(width: 10),
                                                const Text(
                                                  'Domains:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: AppColors.primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            ...List<int>.from(
                                              workerData!['workerProfile']
                                                  ['workerDomains'],
                                            ).map((domain) => Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 28.0),
                                                  child: Text(
                                                    '- ${domainNames[domain] ?? "Unknown"}',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor),
                                                  ),
                                                )),
                                            const SizedBox(height: 10),
                                            // const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.build,
                                                    color: Colors
                                                        .amber), // Choose an appropriate icon
                                                const SizedBox(width: 10),
                                                const Text(
                                                  'Skills:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: AppColors.primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            ...List<String>.from(
                                              workerData!['workerProfile']
                                                  ['workerSkills'],
                                            ).map((skillId) => Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 28.0),
                                                  child: Text(
                                                    '- ${skillMap[skillId] ?? "Unknown Skill"}',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor),
                                                  ),
                                                )),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ),
                            // SafeArea(
                            // child: Padding(
                            // padding: const EdgeInsets.all(6.0),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 6),
                              child: LoginRegisterButton(
                                onPressed: () {
                                  _showHiringDialog();
                                },
                                text: "Hiring",
                              ),
                            ),
                            // ),
                            // )
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
