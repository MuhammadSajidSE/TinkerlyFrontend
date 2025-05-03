// // ignore_for_file: avoid_unnecessary_containers

// import 'package:flutter/material.dart';

// class Labourprofile extends StatefulWidget {
//   const Labourprofile({super.key});

//   @override
//   State<Labourprofile> createState() => _LabourprofileState();
// }

// class _LabourprofileState extends State<Labourprofile> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(" Labour Profile"),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/models/usermodel.dart';

class Labourprofile extends StatelessWidget {
  const Labourprofile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Center(child: Text("No user data available."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: user.avatarId != null
                ? NetworkImage("http://150.136.5.153:2280/cdn/${user.avatarId}.png")
                : null,
            child: user.avatarId == null
                ? const Icon(Icons.person, size: 40)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailTile("Name", user.name),
        _buildDetailTile("Email", user.email),
        _buildDetailTile("Phone", user.phone),
        _buildDetailTile("Age", user.age.toString()),
        _buildDetailTile("Address", user.address),
        _buildDetailTile("NIC", user.nic.toString()),

        _buildDetailTile(
            "Role", user.isCustomer ? "Customer" : user.isWorker ? "Worker" : "Both"),
      ],
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
