import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:tinkerly/providers/userprovider.dart';

class CustomerRequestWork extends StatefulWidget {
  const CustomerRequestWork({super.key});

  @override
  State<CustomerRequestWork> createState() => _CustomerRequestWorkState();
}

class _CustomerRequestWorkState extends State<CustomerRequestWork> {
  List<dynamic> requestData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    String userToken = user!.token;

    final url = Uri.parse('http://150.136.5.153:2279/customer/requests');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $userToken'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        requestData = data['data']
            .where(
                (request) => request['status'] == 0 || request['status'] == 1)
            .toList();
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Request Work'),
      ),
      body: requestData.isEmpty
          ? Center(
              child: Text(
                'No work on pending',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: requestData.length,
              itemBuilder: (context, index) {
                var request = requestData[index];
                var avatarId = request['worker']['avatarId'];
                var workerName = request['worker']['userDetails']['name'];
                var description = request['description'];
                var status = request['status'];

                // Define colors based on status
                Color borderColor =
                    status == 1 ? Colors.red.shade900 : Colors.green.shade900;
                Color backgroundColor =
                    status == 1 ? Colors.red.shade100 : Colors.green.shade100;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: backgroundColor, // light red / light green
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: borderColor, // dark red / dark green
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: avatarId != null
                          ? NetworkImage(
                              "http://150.136.5.153:2280/cdn/$avatarId.png")
                          : null,
                      child: avatarId == null ? const Icon(Icons.person) : null,
                    ),
                    title: Text(
                      workerName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(description),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: status == 1
                            ? Colors.red.shade300
                            : Colors.green.shade300, // RED if 1, GREEN if 0
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status == 1
                            ? 'Rejected'
                            : 'Pending', // Text also matches
                        style: TextStyle(
                          color: Colors
                              .black, // Always black text (clear for both backgrounds)
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
