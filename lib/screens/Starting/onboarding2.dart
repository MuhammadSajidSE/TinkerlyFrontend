import 'package:flutter/material.dart';
import 'package:tinkerly/screens/Starting/onboarding3.dart';

class Onboarding2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding 2'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Onboarding3Screen()));
                },
          
          child: Text('Go to Onboarding 3'),
        ),
      ),
    );
  }
}