// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart'; // Make sure you import provider
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
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchResponses();
// //   }

// //   Future<void> fetchResponses() async {
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

// //       if (response.statusCode == 200) {
// //         final body = json.decode(response.body);
// //         setState(() {
// //           responses = body['data'];
// //           isLoading = false;
// //         });
// //       } else {
// //         setState(() {
// //           isLoading = false;
// //         });
// //         print('Failed to load responses');
// //       }
// //     } catch (e) {
// //       setState(() {
// //         isLoading = false;
// //       });
// //       print('Error: $e');
// //     }
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
// //           return Card(
// //             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //             elevation: 4,
// //             shape:
// //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //             child: ListTile(
// //               title: Text(item['workRequestId'] ?? 'No ID'),
// //               subtitle: Row(
// //                 children: [
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       // Handle Accept action
// //                       print('Accepted ${item['workRequestId']}');
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.green,
// //                     ),
// //                     child: const Text('Accept'),
// //                   ),
// //                   const SizedBox(width: 10),
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       // Handle Reject action
// //                       print('Rejected ${item['workRequestId']}');
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.red,
// //                     ),
// //                     child: const Text('Reject'),
// //                   ),
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
// import 'package:intl/intl.dart'; // Add intl for date formatting
// import 'package:tinkerly/providers/userprovider.dart';

// class CustomerResponsework extends StatefulWidget {
//   const CustomerResponsework({super.key});

//   @override
//   State<CustomerResponsework> createState() => _CustomerResponseworkState();
// }

// class _CustomerResponseworkState extends State<CustomerResponsework> {
//   List<dynamic> responses = [];
//   Map<String, dynamic> requestDetails = {};
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
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

//       final requestResponse = await http.get(
//         Uri.parse('http://150.136.5.153:2279/customer/requests'),
//         headers: {
//           'Authorization': 'Bearer $userToken',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200 && requestResponse.statusCode == 200) {
//         final responseBody = json.decode(response.body);
//         final requestBody = json.decode(requestResponse.body);

//         setState(() {
//           responses = responseBody['data'];
//           requestDetails = requestBody;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         print('Failed to load responses or requests');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error: $e');
//     }
//   }

//   // Get worker name, avatarId and description based on requestId
//   List<dynamic> getWorkerName(String requestId, String jsonData) {
//     var data = jsonDecode(jsonData);
//     var result = [];
//     for (var request in data['data']) {
//       if (request['requestId'] == requestId) {
//         result.add(request['worker']['userDetails']['name']);
//         result.add(request['worker']['avatarId']);
//         result.add(request["description"]);
//         return result;
//       }
//     }
//     return [];
//   }

//   String formatDate(String dateStr) {
//     try {
//       final dateTime = DateTime.parse(dateStr);
//       return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
//     } catch (e) {
//       return dateStr;
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
//           final status = item['status'];
//           final workerDetails =
//               getWorkerName(requestId, json.encode(requestDetails));

//           final workerName =
//               workerDetails.isNotEmpty ? workerDetails[0] : 'Unknown';
//           final workerAvatarId =
//               workerDetails.isNotEmpty ? workerDetails[1] : 'No Avatar';
//           final description =
//               workerDetails.isNotEmpty ? workerDetails[2] : 'No Description';

//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             elevation: 4,
//             color:
//                 status == 1 ? Colors.red[100] : null, // Color red if status==1
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: ListTile(
//               onTap: () {
//                 // Show popup when tapping
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: const Text('Work Request Details'),
//                       content: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Start Date: ${formatDate(item['startDate'])}'),
//                           Text('End Date: ${formatDate(item['endDate'])}'),
//                           Text('Price: \$${item['cost']}'),
//                         ],
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text('Close'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey[300],
//                 child: Text(workerName.isNotEmpty ? workerName[0] : '?'),
//               ),
//               title: Text(workerName),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Description: $description'),
//                   Text('Avatar ID: $workerAvatarId'),
//                   const SizedBox(height: 8),
//                   if (status != 1) // ✅ Only show buttons when status != 1
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             print('Accepted $requestId');
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                           child: const Text('Accept'),
//                         ),
//                         const SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             print('Rejected $requestId');
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

class CustomerResponsework extends StatefulWidget {
  const CustomerResponsework({super.key});

  @override
  State<CustomerResponsework> createState() => _CustomerResponseworkState();
}

class _CustomerResponseworkState extends State<CustomerResponsework> {
  List<dynamic> responses = [];
  Map<String, dynamic> requestDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
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

      final requestResponse = await http.get(
        Uri.parse('http://150.136.5.153:2279/customer/requests'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 && requestResponse.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final requestBody = json.decode(requestResponse.body);

        setState(() {
          responses = responseBody['data'];
          requestDetails = requestBody;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load responses or requests');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  // 🔥 Function to approve or reject work
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isApproved ? 'Request Approved' : 'Request Rejected')),
        );
        fetchData(); // ✅ Refresh after success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update status')),
        );
      }
    } catch (e) {
      print('Error approving/rejecting: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to server')),
      );
    }
  }

  List<dynamic> getWorkerName(String requestId, String jsonData) {
    var data = jsonDecode(jsonData);
    var result = [];
    for (var request in data['data']) {
      if (request['requestId'] == requestId) {
        result.add(request['worker']['userDetails']['name']);
        result.add(request['worker']['avatarId']);
        result.add(request["description"]);
        result.add(request['startDate']);
        result.add(request['endDate']);
        result.add(request['price']);
        return result;
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (responses.isEmpty) {
      return const Center(child: Text('No responses found.'));
    } else {
      return ListView.builder(
        itemCount: responses.length,
        itemBuilder: (context, index) {
          final item = responses[index];
          final requestId = item['workRequestId'];
          final status = item['status'];

          final workerDetails =
              getWorkerName(requestId, json.encode(requestDetails));

          final workerName =
              workerDetails.isNotEmpty ? workerDetails[0] : 'Unknown';
          final workerAvatarId =
              workerDetails.isNotEmpty ? workerDetails[1] : 'No Avatar';
          final description =
              workerDetails.isNotEmpty ? workerDetails[2] : 'No Description';
          final startDate =
              workerDetails.isNotEmpty ? workerDetails[3] : 'No Start Date';
          final endDate =
              workerDetails.isNotEmpty ? workerDetails[4] : 'No End Date';
          final price =
              workerDetails.isNotEmpty ? workerDetails[5] : 'No Price';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: status == 1 ? Colors.red[100] : Colors.white,
            child: ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Work Details'),
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
                backgroundColor: Colors.grey[300],
                child: Text(workerName[0]), // Show first letter
              ),
              title: Text(workerName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: $description'),
                  Text('Avatar ID: $workerAvatarId'),
                  const SizedBox(height: 8),
                  if (status != 1) // ✅ Only show if status != 1
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            approveOrReject(requestId, true); // Accept = true
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Accept'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            approveOrReject(requestId, false); // Reject = false
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
