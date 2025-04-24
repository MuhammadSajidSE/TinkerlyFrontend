import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinkerly/screens/Authentication/login.dart';
import 'package:tinkerly/screens/Chatting/login.dart';

class CustomerSignupPage extends StatefulWidget {
  const CustomerSignupPage({super.key});

  @override
  State<CustomerSignupPage> createState() => _CustomerSignupPageState();
}

class _CustomerSignupPageState extends State<CustomerSignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _avatarId;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final extension = pickedFile.path.split('.').last.toLowerCase();
      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Only PNG and JPG images are allowed')),
        );
        return;
      }

      setState(() {
        _image = File(pickedFile.path);
      });

      try {
        final bytes = await _image!.readAsBytes();
        final base64Image = base64Encode(bytes);

        final imageResponse = await http.post(
          Uri.parse('http://150.136.5.153:2279/media/save'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'image': base64Image}),
        );

        if (imageResponse.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image upload failed.')),
          );
          return;
        }

        final imageJson = jsonDecode(imageResponse.body);

        if (imageJson['errored'] == true || imageJson['data'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image upload error')),
          );
          return;
        }

        setState(() {
          _avatarId = imageJson['data'];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully!')),
        );
      } catch (e) {
        print('Image upload error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  Future<void> registerUserChat() async {
    String phone = _phoneController.text.trim();
    String name = _nameController.text.trim();

    if (phone.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter all details")),
      );
      return;
    }

    // Save user to Firebase
    dbRef.child('users').child(phone).set({'name': name, 'phone': phone});

    // Store in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Chatphone', phone);
    await prefs.setString('Chatname', name);
  }

  Future<void> _signup() async {
    if (_avatarId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select and upload an image first')),
      );
      return;
    }

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _nicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final String userId = DateTime.now().millisecondsSinceEpoch.toString();
      final String registrationDate = DateTime.now().toIso8601String();

      final Map<String, dynamic> requestData = {
        "userProfile": {
          "userId": '',
          "avatarId": _avatarId,
          "registrationDate": registrationDate,
          "access": 0,
          "averageRating": 0,
          "userDetails": {
            "userId": userId,
            "name": _nameController.text.trim(),
            "email": _emailController.text.trim(),
            "phone": _phoneController.text.trim(),
            "age": int.tryParse(_ageController.text.trim()) ?? 0,
            "address": _addressController.text.trim(),
            "nic": int.tryParse(_nicController.text.trim()) ?? 0,
          },
          "administratorProfile": {
            "banAuthority": false,
          },
          "customerProfile": {}
        },
        "username": _emailController.text.trim(),
        "password": _passwordController.text.trim()
      };

      final registerResponse = await http.post(
        Uri.parse('http://150.136.5.153:2279/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      print('Registration Status: ${registerResponse.statusCode}');
      print('Response: ${registerResponse.body}');

      if (registerResponse.statusCode == 200) {
        await registerUserChat();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${registerResponse.body}')),
        );
      }
    } catch (e) {
      print('Signup error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _nicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            TextButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text("Pick Profile Image"),
              onPressed: _pickImage,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: _nicController,
              decoration: InputDecoration(labelText: "NIC"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: Text("Signup as Customer"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
