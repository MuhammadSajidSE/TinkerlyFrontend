import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinkerly/screens/Authentication/login.dart';
import 'package:tinkerly/screens/Chatting/login.dart';

class LabourSignupPage extends StatefulWidget {
  const LabourSignupPage({super.key});

  @override
  State<LabourSignupPage> createState() => _LabourSignupPageState();
}

class _LabourSignupPageState extends State<LabourSignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _yearofexperience = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  int? selectedDomain;
  String? selectedSkill;
  List<Map<String, dynamic>> allSkills = [];
  List<String> filteredSkills = [];

  var selectedWorksDomainIndex = [];
  var selectedWorksSkillId = [];

  final Map<int, String> domainMap = {
    0: 'Carpentry',
    1: 'Electrical',
    2: 'Plumbing',
    3: 'Masonry',
    4: 'Welding',
  };

  @override
  void initState() {
    super.initState();
    fetchSkills();
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

  Future<void> fetchSkills() async {
    try {
      final response =
          await http.get(Uri.parse('http://150.136.5.153:2279/work/details'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          allSkills = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      } else {
        print("Failed to load skills");
      }
    } catch (e) {
      print("Error fetching skills: $e");
    }
  }

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
    }
  }

  void _addWork() {
    if (selectedDomain == null || selectedSkill == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both domain and skill')),
      );
      return;
    }

    final skillMap = allSkills.firstWhere(
      (skill) =>
          skill['type'] == selectedSkill && skill['domain'] == selectedDomain,
      orElse: () => {},
    );

    if (skillMap.isNotEmpty) {
      setState(() {
        selectedWorksDomainIndex.add(selectedDomain!);
        selectedWorksSkillId.add(skillMap['id']);
        selectedDomain = null;
        selectedSkill = null;
        filteredSkills.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Work added successfully')),
      );
    }
  }

  Future<void> _signup() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _nicController.text.isEmpty ||
        _yearofexperience.text.isEmpty ||
        selectedWorksSkillId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please fill in all fields and add at least one work')),
      );
      return;
    }

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
          SnackBar(content: Text('Image upload failed')),
        );
        return;
      }

      final imageJson = jsonDecode(imageResponse.body);
      final String avatarId = imageJson['data'];
      final String userId = DateTime.now().millisecondsSinceEpoch.toString();
      final String registrationDate = DateTime.now().toIso8601String();

      final Map<String, dynamic> requestData = {
        "userProfile": {
          "userId": '',
          "avatarId": avatarId,
          "registrationDate": registrationDate,
          "access": 0,
          "averageRating": 0,
          "userDetails": {
            "userId": '',
            "name": _nameController.text.trim(),
            "email": _emailController.text.trim(),
            "phone": _phoneController.text.trim(),
            "age": int.tryParse(_ageController.text.trim()) ?? 0,
            "address": _addressController.text.trim(),
            "nic": int.tryParse(_nicController.text.trim()) ?? 0,
          },
          "administratorProfile": {"banAuthority": false},
          "customerProfile": null,
          "workerProfile": {
            "yearsOfExperience":
                int.tryParse(_yearofexperience.text.trim()) ?? 0,
            "workerDomains": selectedWorksDomainIndex,
            "workerEducation": [(_educationController.text.trim())],
            "workerSkills": selectedWorksSkillId,
          }
        },
        "username": _emailController.text.trim(),
        "password": _passwordController.text.trim()
      };

      final registerResponse = await http.post(
        Uri.parse('http://150.136.5.153:2279/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (registerResponse.statusCode == 200) {
        await registerUserChat();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful!')),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${registerResponse.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
    _yearofexperience.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Labour Signup")),
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
                decoration: InputDecoration(labelText: "Name")),
            TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email")),
            TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone")),
            TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true),
            TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number),
            TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Address")),
            TextField(
                controller: _nicController,
                decoration: InputDecoration(labelText: "NIC"),
                keyboardType: TextInputType.number),
            TextField(
                controller: _yearofexperience,
                decoration: InputDecoration(labelText: "Year of Experience"),
                keyboardType: TextInputType.number),
            TextField(
              controller: _educationController,
              decoration: InputDecoration(labelText: "Education"),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedDomain,
              decoration: InputDecoration(labelText: "Select Domain"),
              items: domainMap.entries
                  .map((entry) => DropdownMenuItem<int>(
                      value: entry.key, child: Text(entry.value)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDomain = value;
                  selectedSkill = null;
                  filteredSkills = allSkills
                      .where((skill) => skill['domain'] == value)
                      .map((skill) => skill['type'].toString())
                      .toList();
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedSkill,
              decoration: InputDecoration(labelText: "Select Skill"),
              items: filteredSkills
                  .map((skill) => DropdownMenuItem<String>(
                        value: skill,
                        child: Text(skill),
                      ))
                  .toList(),
              onChanged: selectedDomain == null
                  ? null
                  : (value) {
                      setState(() {
                        selectedSkill = value;
                      });
                    },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addWork,
              child: Text("Add Work Skill"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: Text("Signup as Labour"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
