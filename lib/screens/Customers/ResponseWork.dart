// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:tinkerly/providers/userprovider.dart';

// // class CustomerResponsework extends StatefulWidget {
// //   const CustomerResponsework({super.key});

// //   @override
// //   State<CustomerResponsework> createState() => _CustomerResponseworkState();
// // }

// // class _CustomerResponseworkState extends State<CustomerResponsework> {
// //   List<dynamic> responses = [];
// //   Map<String, dynamic> requestDetails = {};
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchData();
// //   }

// //   Future<void> fetchData() async {
// //     setState(() {
// //       isLoading = true;
// //     });

// //     try {
// //       final user = Provider.of<UserProvider>(context, listen: false).user;
// //       String userToken = user!.token;

// //       final response = await http.get(
// //         Uri.parse('http://150.136.5.153:2279/customer/responses'),
// //         headers: {
// //           'Authorization': 'Bearer $userToken',
// //           'Content-Type': 'application/json',
// //         },
// //       );

// //       final requestResponse = await http.get(
// //         Uri.parse('http://150.136.5.153:2279/customer/requests'),
// //         headers: {
// //           'Authorization': 'Bearer $userToken',
// //           'Content-Type': 'application/json',
// //         },
// //       );

// //       if (response.statusCode == 200 && requestResponse.statusCode == 200) {
// //         final responseBody = json.decode(response.body);
// //         final requestBody = json.decode(requestResponse.body);

// //         setState(() {
// //           responses = responseBody['data'];
// //           requestDetails = requestBody;
// //           isLoading = false;
// //         });
// //       } else {
// //         setState(() {
// //           isLoading = false;
// //         });
// //         print('Failed to load responses or requests');
// //       }
// //     } catch (e) {
// //       setState(() {
// //         isLoading = false;
// //       });
// //       print('Error: $e');
// //     }
// //   }

// //   // 🔥 Function to approve or reject work
// //   Future<void> approveOrReject(String requestId, bool isApproved) async {
// //     try {
// //       final user = Provider.of<UserProvider>(context, listen: false).user;
// //       String userToken = user!.token;

// //       final response = await http.post(
// //         Uri.parse('http://150.136.5.153:2279/work/approve'),
// //         headers: {
// //           'Authorization': 'Bearer $userToken',
// //           'Content-Type': 'application/json',
// //         },
// //         body: jsonEncode({
// //           'requestId': requestId,
// //           'isApproved': isApproved,
// //         }),
// //       );

// //       if (response.statusCode == 200) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(isApproved ? 'Request Approved' : 'Request Rejected')),
// //         );
// //         fetchData(); // ✅ Refresh after success
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Failed to update status')),
// //         );
// //       }
// //     } catch (e) {
// //       print('Error approving/rejecting: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Error connecting to server')),
// //       );
// //     }
// //   }

// //   List<dynamic> getWorkerName(String requestId, String jsonData) {
// //     var data = jsonDecode(jsonData);
// //     var result = [];
// //     for (var request in data['data']) {
// //       if (request['requestId'] == requestId) {
// //         result.add(request['worker']['userDetails']['name']);
// //         result.add(request['worker']['avatarId']);
// //         result.add(request["description"]);
// //         result.add(request['startDate']);
// //         result.add(request['endDate']);
// //         result.add(request['price']);
// //         return result;
// //       }
// //     }
// //     return [];
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (isLoading) {
// //       return const Center(child: CircularProgressIndicator());
// //     } else if (responses.isEmpty) {
// //       return const Center(child: Text('No responses found.'));
// //     } else {
// //       return ListView.builder(
// //         itemCount: responses.length,
// //         itemBuilder: (context, index) {
// //           final item = responses[index];
// //           final requestId = item['workRequestId'];
// //           final status = item['status'];

// //           final workerDetails =
// //               getWorkerName(requestId, json.encode(requestDetails));

// //           final workerName =
// //               workerDetails.isNotEmpty ? workerDetails[0] : 'Unknown';
// //           final workerAvatarId =
// //               workerDetails.isNotEmpty ? workerDetails[1] : 'No Avatar';
// //           final description =
// //               workerDetails.isNotEmpty ? workerDetails[2] : 'No Description';
// //           final startDate =
// //               workerDetails.isNotEmpty ? workerDetails[3] : 'No Start Date';
// //           final endDate =
// //               workerDetails.isNotEmpty ? workerDetails[4] : 'No End Date';
// //           final price =
// //               workerDetails.isNotEmpty ? workerDetails[5] : 'No Price';

// //           return Card(
// //             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //             elevation: 4,
// //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //             color: status == 1 ? Colors.red[100] : Colors.white,
// //             child: ListTile(
// //               onTap: () {
// //                 showDialog(
// //                   context: context,
// //                   builder: (_) => AlertDialog(
// //                     title: Text('Work Details'),
// //                     content: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Text('Start: $startDate'),
// //                         Text('End: $endDate'),
// //                         Text('Price: $price'),
// //                       ],
// //                     ),
// //                     actions: [
// //                       TextButton(
// //                         onPressed: () => Navigator.pop(context),
// //                         child: const Text('Close'),
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               },
// //               leading: CircleAvatar(
// //               backgroundImage: 
// //                   NetworkImage(
// //                       "http://150.136.5.153:2280/cdn/${workerAvatarId}.png")
                
// //             ),
// //               title: Text(workerName),
// //               subtitle: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text('Description: $description'),
// //                   const SizedBox(height: 8),
// //                   if (status != 1) // ✅ Only show if status != 1
// //                     Row(
// //                       children: [
// //                         ElevatedButton(
// //                           onPressed: () {
// //                             approveOrReject(requestId, true); // Accept = true
// //                           },
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.green,
// //                           ),
// //                           child: const Text('Accept'),
// //                         ),
// //                         const SizedBox(width: 10),
// //                         ElevatedButton(
// //                           onPressed: () {
// //                             approveOrReject(requestId, false); // Reject = false
// //                           },
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.red,
// //                           ),
// //                           child: const Text('Reject'),
// //                         ),
// //                       ],
// //                     ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       );
// //     }
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:tinkerly/providers/userprovider.dart';

// class CustomerResponsework extends StatefulWidget {
//   const CustomerResponsework({super.key});

//   @override
//   State<CustomerResponsework> createState() => _CustomerResponseworkState();
// }

// class _CustomerResponseworkState extends State<CustomerResponsework> {
//   List<dynamic> responses = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final user = Provider.of<UserProvider>(context, listen: false).user;
//       String userToken = user!.token;

//       final response = await http.get(
//         Uri.parse('http://150.136.5.153:2279/customer/responses'),
//         headers: {
//           'Authorization': 'Bearer $userToken',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseBody = json.decode(response.body);

//         setState(() {
//           responses = responseBody['data'];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         print('Failed to load responses');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error: $e');
//     }
//   }

//   Future<void> approveOrReject(String requestId, bool isApproved) async {
//     try {
//       final user = Provider.of<UserProvider>(context, listen: false).user;
//       String userToken = user!.token;

//       final response = await http.post(
//         Uri.parse('http://150.136.5.153:2279/work/approve'),
//         headers: {
//           'Authorization': 'Bearer $userToken',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'requestId': requestId,
//           'isApproved': isApproved,
//         }),
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content:
//                   Text(isApproved ? 'Request Approved' : 'Request Rejected')),
//         );
//         fetchData();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to update status')),
//         );
//       }
//     } catch (e) {
//       print('Error approving/rejecting: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error connecting to server')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (responses.isEmpty) {
//       return const Center(child: Text('No responses found.'));
//     } else {
//       return ListView.builder(
//         itemCount: responses.length,
//         itemBuilder: (context, index) {
//           final item = responses[index];
//           final requestId = item['workRequestId'];
//           final workRequest = item['workRequest'];
//           final worker = workRequest['worker'];
//           final userDetails = worker['userDetails'];
//           final avatarId = worker['avatarId'];
//           final status = item['status'];
//           final description = workRequest['description'];
//           final startDate = item['startDate'];
//           final endDate = item['endDate'];
//           final price = item['cost'];

//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             elevation: 4,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             color: status == 1 ? Colors.red[100] : Colors.white,
//             child: ListTile(
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (_) => AlertDialog(
//                     title: Text('Work Details'),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Start: $startDate'),
//                         Text('End: $endDate'),
//                         Text('Price: $price'),
//                       ],
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('Close'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               leading: CircleAvatar(
//                 backgroundImage:
//                     NetworkImage("http://150.136.5.153:2280/cdn/$avatarId.png"),
//               ),
//               title: Text(userDetails['name'] ?? 'Unknown'),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Description: $description'),
//                   const SizedBox(height: 8),
//                   if (status != 1)
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             approveOrReject(requestId, true);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                           child: const Text('Accept'),
//                         ),
//                         const SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             approveOrReject(requestId, false);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                           ),
//                           child: const Text('Reject'),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/reusable_components/constants.dart'; // Ensure this import is correct

class CustomerResponsework extends StatefulWidget {
  const CustomerResponsework({super.key});

  @override
  _CustomerResponseworkState createState() => _CustomerResponseworkState();
}

class _CustomerResponseworkState extends State<CustomerResponsework> {
  List<dynamic> responses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      String userToken = user!.token;

      final response = await http.get(
        Uri.parse('http://150.136.5.153:2279/customer/responses'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          responses = responseBody['data'];
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        print('Failed to load responses');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> approveOrReject(String requestId, bool isApproved) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      String userToken = user!.token;

      final response = await http.post(
        Uri.parse('http://150.136.5.153:2279/work/approve'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'requestId': requestId,
          'isApproved': isApproved,
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return; //check
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                isApproved ? 'Request Approved' : 'Request Rejected'),
            backgroundColor: isApproved ? Colors.green : Colors.red,
          ),
        );
        fetchData();
      } else {
        if (!mounted) return; //check
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return; //check
      print('Error approving/rejecting: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error connecting to server'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Customer Responses',
          style: TextStyle(
            fontSize: 22,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        //  bottom: TabBar( // Removed TabBar
        //  controller: _tabController,
        //  indicatorColor: AppColors.primaryColor,
        //  labelColor: AppColors.primaryColor,
        //  unselectedLabelColor: AppColors.secondaryColor,
        //  tabs: const [
        //  Tab(text: 'All'),
        //  Tab(text: 'Pending'),
        //  Tab(text: 'Rejected'),
        //  ],
        //  ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : responses.isEmpty
              ? const Center(
                  child: Text(
                    'No responses found.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: responses.length,
                  itemBuilder: (context, index) {
                    final item = responses[index];
                    final requestId = item['workRequestId'];
                    final workRequest = item['workRequest'];
                    final worker = workRequest['worker'];
                    final userDetails = worker['userDetails'];
                    final avatarId = worker['avatarId'];
                    final status = item['status'];
                    final description = workRequest['description'];
                    final startDate = item['startDate'];
                    final endDate = item['endDate'];
                    final price = item['cost'];

                    return Container(
                       decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primaryColor, AppColors.secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(14), // Match Card's border radius if needed
    ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 6),
                      padding: const EdgeInsets.all(8),
                      // decoration: BoxDecoration(
                      //   color: status == 1
                      //       ? Colors.red[100]
                      //       : AppColors
                      //           .secondaryColor, // Use secondary color here
                      //   borderRadius: BorderRadius.circular(8),
                      //   border: Border.all(
                      //     color: status == 1
                      //         ? Colors.redAccent
                      //         : AppColors
                      //             .primaryColor, // Use primary color here
                      //     width: 0.5,
                      //   ),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: status == 1
                      //           ? Colors.redAccent.withOpacity(0.2)
                      //           : AppColors.primaryColor
                      //               .withOpacity(
                      //                   0.2), // Use primary color here
                      //       spreadRadius: 1,
                      //       blurRadius: 3,
                      //       offset: const Offset(0,
                      //           1), // Slight bottom shadow for better definition
                      //     ),
                      //   ],
                      // ),
                     
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Work Details'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Start: $startDate'),
                                  Text('End: $endDate'),
                                  Text('Price: $price'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.amber,
                          child: avatarId != null
                              ? CircleAvatar(
                                  radius: 23,
                                  backgroundImage: NetworkImage(
                                      "http://150.136.5.153:2280/cdn/$avatarId.png"),
                                )
                              : const CircleAvatar(
                                  radius: 23,
                                  child: Icon(Icons.person),
                                ),
                        ),
                        title: Text(
                          userDetails['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: status == 1
                                ? Colors.white
                                : AppColors
                                    .primaryColor, // Use primary color here
                          ),
                        ),
                        subtitle: Text(
                          'Description: $description',
                          style: TextStyle(
                            color: status == 1
                                ? const Color.fromARGB(255, 231, 230, 230)
                                : AppColors
                                    .secondaryColor, // Use secondary color here
                          ),
                        ),
                        trailing: status != 1
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      approveOrReject(requestId, true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Accept'),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      approveOrReject(requestId, false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Reject'),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    );
                  },
                ),
    );
  }
}

