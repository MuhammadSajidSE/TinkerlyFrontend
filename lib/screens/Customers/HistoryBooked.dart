import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tinkerly/providers/userprovider.dart';

class WorkerHistoryScreen extends StatefulWidget {
  @override
  _WorkerHistoryScreenState createState() => _WorkerHistoryScreenState();
}

class _WorkerHistoryScreenState extends State<WorkerHistoryScreen> {
  List<dynamic> historyData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final token = user!.token;

    final response = await http.get(
      Uri.parse('http://150.136.5.153:2279/customer/history'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (!decodedResponse['errored']) {
        setState(() {
          historyData = decodedResponse['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Custom Header
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.blue,
            child: Text(
              'Worker History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : historyData.isEmpty
                    ? Center(child: Text('No history found'))
                    : ListView.builder(
                        itemCount: historyData.length,
                        itemBuilder: (context, index) {
                          final worker = historyData[index]['workerProfile'];
                          final userDetails = worker['userDetails'];
    
                          final workerName = userDetails['name'] ?? 'No Name';
                          final workerAddress = userDetails['address'] ?? 'No Address';
                          final workerAvatarId = worker['avatarId'] ?? '';
    
                          return Card(
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: workerAvatarId.isNotEmpty
                                    ? NetworkImage("http://150.136.5.153:2280/cdn/$workerAvatarId.png")
                                    : null,
                                child: workerAvatarId.isEmpty
                                    ? Icon(Icons.person, size: 30)
                                    : null,
                              ),
                              title: Text(workerName),
                              subtitle: Text(workerAddress),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
