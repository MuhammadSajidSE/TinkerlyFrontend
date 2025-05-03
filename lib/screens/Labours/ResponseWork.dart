import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tinkerly/providers/userprovider.dart';

class Responsework extends StatelessWidget {
  const Responsework({super.key});

  Future<List<dynamic>> fetchResponses(String token) async {
    final response = await http.get(
      Uri.parse('http://150.136.5.153:2279/worker/responses'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return jsonBody['data'];
    } else {
      throw Exception('Failed to load responses');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    String token = user!.token;

    return FutureBuilder<List<dynamic>>(
      future: fetchResponses(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No responses available.'));
        }

        final responses = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: responses.length,
          itemBuilder: (context, index) {
            final response = responses[index];
            final workRequest = response['workRequest'];
            final customer = workRequest['customer'];
            final customerDetails = customer['userDetails'];
            final avatarId = customer['avatarId'];
            final name = customerDetails['name'];
            final description = workRequest['description'];
            final status = response['status'];

            final bool isPending = status == 0;
            final cardColor = isPending ? Colors.green[100] : Colors.red[100];
            final statusText = isPending ? 'Pending' : 'Rejected';
            final statusColor = isPending ? Colors.green : Colors.red;

            return Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: avatarId != null
                      ? NetworkImage(
                          "http://150.136.5.153:2280/cdn/$avatarId.png")
                      : null,
                  child: avatarId == null
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                title: Text(name ?? "No Name"),
                subtitle: Text(description ?? "No Description"),
                trailing: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
