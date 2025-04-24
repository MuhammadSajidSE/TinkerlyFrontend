// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:tinkerly/models/usermodel.dart';
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/screens/Authentication/login.dart';
import 'package:tinkerly/screens/Customers/mainCustomer.dart';
import 'package:tinkerly/screens/Labours/mainLabour.dart';

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding Screen 3'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var token = prefs.getString('UserToken');

            if (token == null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            } else {
              final tokenUrl =
                  Uri.parse('http://150.136.5.153:2279/authenticate/token');

              try {
                final response = await http.post(
                  tokenUrl,
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    "token": token,
                  }),
                );

                if (response.statusCode == 200) {
                  final tokenData = jsonDecode(response.body);

                  if (tokenData['errored'] == false) {
                    final profile = tokenData['data']['profile'];
                    final userDetails = profile['userDetails'];
                    final customerProfile = profile['customerProfile'];
                    final workerProfile = profile['workerProfile'];

                    final userModel = UserModel(
                      avatarId: profile['avatarId'] ?? '',
                      userId: userDetails['userId'] ?? '',
                      name: userDetails['name'] ?? '',
                      email: userDetails['email'] ?? '',
                      phone: userDetails['phone'] ?? '',
                      age: userDetails['age'] ?? 0,
                      address: userDetails['address'] ?? '',
                      nic: userDetails['nic'] ?? 0,
                      token: tokenData['data']['token'] ?? '',
                      isCustomer: workerProfile == null,
                      isWorker: customerProfile == null,
                    );

                    Provider.of<UserProvider>(context, listen: false)
                        .setUser(userModel);
                    print("User stored in provider successfully ✅");

                    if (workerProfile == null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainCustomer()),
                      );
                    } else if (customerProfile == null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Mainlabour()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('This user has both roles.')),
                      );
                    }
                  } else {
                    print('Token Check Error: ${tokenData['errorMessage']}');
                  }
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );

                  print(
                      'Token check failed with status code: ${response.statusCode}');
                }
              } catch (e) {
                print('Token Check Exception: $e');
              }
            }
          },
          child: Text('Go to Login Screen'),
        ),
      ),
    );
  }
}
