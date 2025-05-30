// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:tinkerly/providers/userprovider.dart';
// import 'package:tinkerly/screens/Labours/AcceptWork.dart';

// class WorkerRequestsPage extends StatefulWidget {
//   const WorkerRequestsPage({super.key});

//   @override
//   State<WorkerRequestsPage> createState() => _WorkerRequestsPageState();
// }

// class _WorkerRequestsPageState extends State<WorkerRequestsPage> {
//   List<dynamic> requests = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchRequests();
//   }

// Future<void> fetchRequests() async {
//   final user = Provider.of<UserProvider>(context, listen: false).user;
//   final token = user?.token;

//   try {
//     final response = await http.get(
//       Uri.parse('http://150.136.5.153:2279/worker/requests'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       setState(() {
//         // ✨ Filter the list where status == 0
//         requests = (data['data'] as List).where((request) => request['status'] == 0).toList();
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load requests');
//     }
//   } catch (e) {
//     print('Error fetching requests: $e');
//     setState(() {
//       isLoading = false;
//     });
//   }
// }


//   Widget buildRequestTile(dynamic request) {
//     final customer = request['customer'];
//     final userDetails = customer['userDetails'];
//     final name = userDetails['name'];
//     final address = userDetails['address'];
//     final avatarId = customer['avatarId'];
//     final imageUrl = 'http://150.136.5.153:2280/cdn/$avatarId.png';

//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         address,
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(imageUrl),
//                   radius: 25,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     handleAccept(request);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                   ),
//                   child: const Text('Accept'),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     handleReject(request['requestId']);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                   ),
//                   child: const Text('Reject'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// Future<void> handleAccept(dynamic request) async {
//   final customer = request['customer'];
//   final userDetails = customer['userDetails'];
//   final workstatus =  request['status']; 
//   // Extracting data
//   final String requestId = request['requestId'];  // No need for .toString() as it's already a string
//   final String name = userDetails['name'];
//   final String avatarId = customer['avatarId'];
//   final String address = userDetails['address'];
//   final String phone = userDetails['phone'];  // Ensure the phone exists in the data
//   final String description = request['description'];  // Ensure the description exists
//   final String workDetailsId = request['workDetailsId'];  // Ensure workDetailsId exists
//   print('Request Type: ${request.runtimeType}');
// print('Request Content: $request');

//   // Navigate to AcceptWork screen and pass necessary data
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => AcceptWork(
//         name: name,
//         avatarId: avatarId,
//         address: address,
//         phone: phone,
//         description: description,
//         requestId: requestId,  // Passing requestId as a string
//         workDetailsId: workDetailsId,  // Passing workDetailsId as a string
//       ),
//     ),
//   );
// }


// Future<void> handleReject(String requestId) async {
//   final user = Provider.of<UserProvider>(context, listen: false).user;
//   final token = user?.token;

//   if (token == null) {
//     print('Token is missing');
//     return;
//   }

//   try {
//     final response = await http.post(
//       Uri.parse('http://150.136.5.153:2279/work/approve'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         "requestId": requestId,
//         "isApproved": false,
//       }),
//     );

//     if (response.statusCode == 200) {
//       print('Request rejected successfully');

//       // ✨ Remove rejected card locally
//       setState(() {
//         requests.removeWhere((req) => req['requestId'] == requestId);
//       });

//       // (Optional) Show a snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Request Rejected Successfully!')),
//       );
//     } else {
//       print('Failed to reject request: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error rejecting request: $e');
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Worker Requests'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : requests.isEmpty
//               ? const Center(child: Text("No requests found."))
//               : ListView.builder(
//                   itemCount: requests.length,
//                   itemBuilder: (context, index) =>
//                       buildRequestTile(requests[index]),
//                 ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/screens/Labours/AcceptWork.dart';

class WorkerRequestsPage extends StatefulWidget {
  const WorkerRequestsPage({super.key});

  @override
  State<WorkerRequestsPage> createState() => _WorkerRequestsPageState();
}

class _WorkerRequestsPageState extends State<WorkerRequestsPage> {
  List<dynamic> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final token = user?.token;

    try {
      final response = await http.get(
        Uri.parse('http://150.136.5.153:2279/worker/requests'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // ✨ Show only status 0 and 1
          requests = (data['data'] as List).where((r) => r['status'] == 0 || r['status'] == 1).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load requests');
      }
    } catch (e) {
      print('Error fetching requests: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildRequestTile(dynamic request) {
    final customer = request['customer'];
    final userDetails = customer['userDetails'];
    final name = userDetails['name'];
    final address = userDetails['address'];
    final avatarId = customer['avatarId'];
    final imageUrl = 'http://150.136.5.153:2280/cdn/$avatarId.png';
    final status = request['status'];

    return Card(
      color: status == 1 ? Colors.red[100] : null,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 25,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (status == 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      handleAccept(request);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Accept'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      handleReject(request['requestId']);
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
  }

  Future<void> handleAccept(dynamic request) async {
    final customer = request['customer'];
    final userDetails = customer['userDetails'];

    final String requestId = request['requestId'];
    final String name = userDetails['name'];
    final String avatarId = customer['avatarId'];
    final String address = userDetails['address'];
    final String phone = userDetails['phone'];
    final String description = request['description'];
    final String workDetailsId = request['workDetailsId'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcceptWork(
          name: name,
          avatarId: avatarId,
          address: address,
          phone: phone,
          description: description,
          requestId: requestId,
          workDetailsId: workDetailsId,
        ),
      ),
    );
  }

  Future<void> handleReject(String requestId) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final token = user?.token;

    if (token == null) {
      print('Token is missing');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://150.136.5.153:2279/work/approve'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "requestId": requestId,
          "isApproved": false,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          requests.removeWhere((req) => req['requestId'] == requestId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request Rejected Successfully!')),
        );
      } else {
        print('Failed to reject request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error rejecting request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Requests'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
              ? const Center(child: Text("No requests found."))
              : ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) =>
                      buildRequestTile(requests[index]),
                ),
    );
  }
}
