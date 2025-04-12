import 'package:flutter/material.dart';
import 'package:tinkerly/screens/Starting/onboarding2.dart';

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding 1'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Onboarding2Screen()));
          },
          child: Text('Go to Onboarding 2'),
        ),
      ),
    );
  }
}
