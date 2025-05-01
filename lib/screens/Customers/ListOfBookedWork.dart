// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:tinkerly/providers/userprovider.dart';

// class BookingListWidget extends StatefulWidget {
//   const BookingListWidget({Key? key}) : super(key: key);

//   @override
//   State<BookingListWidget> createState() => _BookingListWidgetState();
// }

// class _BookingListWidgetState extends State<BookingListWidget> {
//   List bookings = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchBookings();
//   }

//   Future<void> fetchBookings() async {
//     try {
//       final user = Provider.of<UserProvider>(context, listen: false).user;
//       final token = user!.token;

//       final response = await http.get(
//         Uri.parse('http://150.136.5.153:2279/customer/bookings'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         setState(() {
//           bookings = body['data'];
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load bookings');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       debugPrint('Error fetching bookings: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (bookings.isEmpty) {
//       return const Center(child: Text('No bookings found.'));
//     }

//     return ListView.builder(
//       itemCount: bookings.length,
//       itemBuilder: (context, index) {
//         final booking = bookings[index];
//         final workerProfile = booking['workerProfile'];
//         final userDetails = workerProfile?['userDetails'];
//         final workerName = userDetails?['name'] ?? 'Unknown';
//         final workDetailsId = booking['workDetailsId'] ?? 'N/A';
//         final workerAvatarId = workerProfile?['avatarId'];

//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundImage: workerAvatarId != null
//                   ? NetworkImage(
//                       "http://150.136.5.153:2280/cdn/$workerAvatarId.png")
//                   : null,
//               child: workerAvatarId == null
//                   ? const Icon(Icons.person)
//                   : null,
//             ),
//             title: Text(workerName),
//             subtitle: Text('Work ID: $workDetailsId'),
//           ),
//         );
//       },
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/reusable_components/constants.dart';
import 'package:tinkerly/screens/Customers/DetailBooked.dart';

// import 'user_provider.dart'; // Your UserProvider

class BookingListWidget extends StatefulWidget {
  const BookingListWidget({Key? key}) : super(key: key);

  @override
  State<BookingListWidget> createState() => _BookingListWidgetState();
}

class _BookingListWidgetState extends State<BookingListWidget> {
  List bookings = [];
  Map<String, String> workDetailsMap = {}; // workDetailId -> work type
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final token = user!.token;

      // Fetch bookings
      final bookingResponse = await http.get(
        Uri.parse('http://150.136.5.153:2279/customer/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Fetch work details
      final workDetailsResponse = await http.get(
        Uri.parse('http://150.136.5.153:2279/work/details'),
      );

      if (bookingResponse.statusCode == 200 && workDetailsResponse.statusCode == 200) {
        final bookingBody = jsonDecode(bookingResponse.body);
        final workDetailsBody = jsonDecode(workDetailsResponse.body);

        // Create a map of workDetailId to work type
        final List workData = workDetailsBody['data'];
        workDetailsMap = {
          for (var item in workData) item['id']: item['type'],
        };

        setState(() {
          bookings = bookingBody['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings found.'));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Customer Request Work', style: TextStyle(
              fontSize: 22,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold),),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          final workerProfile = booking['workerProfile'];
          final userDetails = workerProfile?['userDetails'];
          final workerName = userDetails?['name'] ?? 'Unknown';
          final workDetailsId = booking['workDetailsId'] ?? 'N/A';
          final workTypeName = workDetailsMap[workDetailsId] ?? 'Unknown Work Type';
          final workerAvatarId = workerProfile?['avatarId'];
      
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
      leading:CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.amber,
                      child: CircleAvatar(
                        radius: 23,
        backgroundImage: workerAvatarId != null
            ? NetworkImage("http://150.136.5.153:2280/cdn/$workerAvatarId.png")
            : null,
        child: workerAvatarId == null ? const Icon(Icons.person) : null,
      ),),
      title: Text(workerName),
      subtitle: Text('Work: $workTypeName'),
         onTap: () {
        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBooked(
          bookingId: booking['bookingId'] ?? '',
          workName: workDetailsMap[booking['workDetailsId']] ?? 'Unknown Work',
          workPrice: booking['workPrice']?.toString() ?? '',
          workerAvatarId: booking['workerProfile']?['avatarId'] ?? '',
          workerName: booking['workerProfile']?['userDetails']?['name'] ?? 'Unknown',
          workerAddress: booking['workerProfile']?['userDetails']?['address'] ?? '',
          yearsOfExperience: booking['workerProfile']?['workerProfile']?['yearsOfExperience']?.toString() ?? '',
          workerEducation: (booking['workerProfile']?['workerProfile']?['workerEducation'] as List?)?.join(", ") ?? '',
          startDate: booking['startDate'] ?? '',
          endDate: booking['endDate'] ?? '',
          description: booking['description'] ?? '',
        ),
      ),
        );
      },
        ),
      );
      
        },
      ),
    );
  }
}
