import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/reusable_components/constants.dart';

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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Customer Request Work', style: TextStyle(
              fontSize: 22,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold),),
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
                    status == 1 ? Colors.amber : Colors.amber;
              
                Color backgroundColor =
                    status == 1 ? AppColors.secondaryColor : AppColors.primaryColor;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: backgroundColor, // light red / light green
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: borderColor, // dark red / dark green
                      width: 0.5,
                    ),
                    boxShadow: [BoxShadow(
                       color:  status == 1 ? AppColors.secondaryColor : AppColors.primaryColor,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    )]
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.amber,
                      child: CircleAvatar(
                        radius: 23,
                        backgroundImage: avatarId != null
                            ? NetworkImage(
                                "http://150.136.5.153:2280/cdn/$avatarId.png",)
                            : null,
                        child: avatarId == null ? const Icon(Icons.person) : null,
                      ),
                    ),
                    title: Text(
                      workerName,
                      style: TextStyle(fontWeight: FontWeight.bold,color: status == 1 ? AppColors.primaryColor : AppColors.secondaryColor),
                    ),
                    subtitle: Text(description,style: TextStyle(color: status == 1 ? AppColors.primaryColor : AppColors.secondaryColor),),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: status == 1
                            ? const Color.fromARGB(255, 206, 54, 54)
                            : const Color.fromARGB(255, 84, 158, 0), // RED if 1, GREEN if 0
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status == 1
                            ? 'Rejected'
                            : 'Pending', // Text also matches
                        style: TextStyle(
                          color: status != 1 ? Colors.white : AppColors.backgroundColor, // Always black text (clear for both backgrounds)
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
