import 'package:flutter/material.dart';
import 'package:tinkerly/screens/Authentication/customerSignup.dart';
import 'package:tinkerly/screens/Authentication/laborSignup.dart';

class SignupSelectionPage extends StatelessWidget {
  const SignupSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Signup Role")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Signup as Customer"),
               onPressed: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerSignupPage()),
                );
              }
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Signup as Labour"),
              onPressed: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LabourSignupPage()),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
