// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinkerly/screens/Authentication/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // Image pickers
  File? _customerImage;
  File? _labourImage;

  final ImagePicker _picker = ImagePicker();

  // Customer controllers
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerEmailController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _customerPasswordController = TextEditingController();

  // Labour controllers
  final TextEditingController _labourNameController = TextEditingController();
  final TextEditingController _labourEmailController = TextEditingController();
  final TextEditingController _labourPhoneController = TextEditingController();
  final TextEditingController _labourPasswordController = TextEditingController();

  void _onToggleTap(int index) {
    setState(() {
      _currentPage = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _pickImage(bool isCustomer) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isCustomer) {
          _customerImage = File(pickedFile.path);
        } else {
          _labourImage = File(pickedFile.path);
        }
      });
    }
  }

  Widget _buildImagePicker(String role, bool isCustomer) {
    final File? image = isCustomer ? _customerImage : _labourImage;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: image != null ? FileImage(image) : null,
          child: image == null
              ? Icon(Icons.person, size: 50, color: Colors.grey)
              : null,
        ),
        TextButton.icon(
          onPressed: () => _pickImage(isCustomer),
          icon: Icon(Icons.camera_alt),
          label: Text('Pick Profile Image'),
        ),
      ],
    );
  }

  Widget _buildSignupForm(
    String role,
    bool isCustomer,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController passwordController,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Signup as $role',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildImagePicker(role, isCustomer),
          SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: 'Phone Number'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle signup logic here
              print('Signup as $role');
            },
            child: Text('Signup'),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('Already have an account? Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: Text('Customer'),
          selected: _currentPage == 0,
          onSelected: (_) => _onToggleTap(0),
          selectedColor: Colors.blue,
          labelStyle: TextStyle(
            color: _currentPage == 0 ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(width: 10),
        ChoiceChip(
          label: Text('Labour'),
          selected: _currentPage == 1,
          onSelected: (_) => _onToggleTap(1),
          selectedColor: Colors.blue,
          labelStyle: TextStyle(
            color: _currentPage == 1 ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _customerPhoneController.dispose();
    _customerPasswordController.dispose();
    _labourNameController.dispose();
    _labourEmailController.dispose();
    _labourPhoneController.dispose();
    _labourPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          _buildToggleButtons(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildSignupForm(
                  'Customer',
                  true,
                  _customerNameController,
                  _customerEmailController,
                  _customerPhoneController,
                  _customerPasswordController,
                ),
                _buildSignupForm(
                  'Labour',
                  false,
                  _labourNameController,
                  _labourEmailController,
                  _labourPhoneController,
                  _labourPasswordController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
