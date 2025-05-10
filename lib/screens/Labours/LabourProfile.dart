// // // ignore_for_file: avoid_unnecessary_containers

// // import 'package:flutter/material.dart';

// // class Labourprofile extends StatefulWidget {
// //   const Labourprofile({super.key});

// //   @override
// //   State<Labourprofile> createState() => _LabourprofileState();
// // }

// // class _LabourprofileState extends State<Labourprofile> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       child: Text(" Labour Profile"),
// //     );
// //   }
// // }



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tinkerly/providers/userprovider.dart';
// import 'package:tinkerly/models/usermodel.dart';

// class Labourprofile extends StatefulWidget {
//   const Labourprofile({super.key});

//   @override
//   State<Labourprofile> createState() => _LabourprofileState();
// }

// class _LabourprofileState extends State<Labourprofile> {
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserProvider>(context).user;

//     if (user == null) {
//       return const Center(child: Text("No user data available."));
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Center(
//           child: CircleAvatar(
//             radius: 50,
//             backgroundImage: user.avatarId != null
//                 ? NetworkImage("http://150.136.5.153:2280/cdn/${user.avatarId}.png")
//                 : null,
//             child: user.avatarId == null
//                 ? const Icon(Icons.person, size: 40)
//                 : null,
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildDetailTile("Name", user.name),
//         _buildDetailTile("Email", user.email),
//         _buildDetailTile("Phone", user.phone),
//         _buildDetailTile("Age", user.age.toString()),
//         _buildDetailTile("Address", user.address),
//         _buildDetailTile("NIC", user.nic.toString()),

//         _buildDetailTile(
//             "Role", user.isCustomer ? "Customer" : user.isWorker ? "Worker" : "Both"),
//       ],
//     );
//   }

//   Widget _buildDetailTile(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "$title: ",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: Text(value, overflow: TextOverflow.ellipsis),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/models/usermodel.dart';
import 'package:tinkerly/reusable_components/constants.dart'; // Ensure this import is correct

class Labourprofile extends StatefulWidget {
  const Labourprofile({super.key});

  @override
  State<Labourprofile> createState() => _LabourprofileState();
}

class _LabourprofileState extends State<Labourprofile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Center(child: Text("No user data available."));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileImage(user.avatarId),
          const SizedBox(height: 20),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
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
                _buildRow(Icons.email, "Email", user.email),
                _buildRow(Icons.phone, "Phone", user.phone),
                _buildRow(Icons.location_on, "Address", user.address),
                _buildRow(Icons.person, "Age", user.age.toString()),
                _buildRow(Icons.badge, "NIC", user.nic.toString()),
                _buildRow(
                  Icons.assignment_ind,
                  "Role",
                  user.isCustomer ? "Customer" : user.isWorker ? "Worker" : "Both",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Styled Profile Image Widget
  Widget _buildProfileImage(String? avatarId) {
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
            backgroundColor: Colors.amber,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: avatarId == null
                  ? null
                  : NetworkImage('http://150.136.5.153:2280/cdn/$avatarId.png'),
              child: avatarId == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build styled rows
  Widget _buildRow(IconData icon, String label, String value) {
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
                style:
                    const TextStyle(fontSize: 16, color: AppColors.primaryColor),
                children: [
                  TextSpan(
                      text: '$label: ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
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

