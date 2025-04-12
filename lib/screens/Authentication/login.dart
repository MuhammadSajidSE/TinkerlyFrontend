// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinkerly/models/usermodel.dart';
import 'package:tinkerly/providers/userprovider.dart';
import 'dart:convert';

import 'package:tinkerly/screens/Authentication/signup.dart';
import 'package:tinkerly/screens/Customers/mainCustomer.dart';
import 'package:tinkerly/screens/Labours/mainLabour.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(
      BuildContext context, String email, String password) async {
    final loginUrl =
        Uri.parse('http://150.136.5.153:2279/authenticate/credentials');

    try {
      final response = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> loginData = jsonDecode(response.body);

        if (loginData['errored'] == false) {
          final token = loginData['data']['token'];
          print('New Token: $token');

          // Store token
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? oldToken = prefs.getString('UserToken');
          if (oldToken != null) {
            print('Old Token: $oldToken');
          }
          await prefs.setString('UserToken', token);

          // Now call /authenticate/token
          await _checkUserRole(context, token);
        } else {
          print('Login Error: ${loginData['errorMessage']}');
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loginData['errorMessage'])),
        );
        }
      } else {
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Login Exception: $e');
    }
  }

  Future<void> _checkUserRole(BuildContext context, String token) async {
    final tokenUrl = Uri.parse('http://150.136.5.153:2279/authenticate/token');

    try {
      final response = await http.post(
        tokenUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "token": token,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> tokenData = jsonDecode(response.body);

        if (tokenData['errored'] == false) {
          final profile = tokenData['data']['profile'];
          final customerProfile = profile['customerProfile'];
          final workerProfile = profile['workerProfile'];

          String message;
          if (workerProfile == null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MainCustomer()));
          } else if (customerProfile == null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Mainlabour()));
          } else {
            message = 'This user has both roles.';
          }
        } else {
          print('Token Check Error: ${tokenData['errorMessage']}');
        }
        final responseData = jsonDecode(response.body);
        final profile = responseData['data']['profile'];

        final userDetails = profile['userDetails'];

        final userModel = UserModel(
          userId: userDetails['userId'],
          name: userDetails['name'],
          email: userDetails['email'],
          phone: userDetails['phone'],
          age: userDetails['age'],
          address: userDetails['address'],
          nic: userDetails['nic'],
          token: responseData['data']['token'],
          isCustomer: profile['workerProfile'] == null,
          isWorker: profile['customerProfile'] == null,
        );

        Provider.of<UserProvider>(context, listen: false).setUser(userModel);
        print("User stored in provider successfully ✅");
      } else {
        print('Token check failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Token Check Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _login(
                    context, _emailController.text, _passwordController.text);
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
