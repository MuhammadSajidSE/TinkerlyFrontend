import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/screens/Authentication/login.dart';
import 'package:tinkerly/screens/Authentication/signup.dart';
import 'package:tinkerly/screens/Starting/onboarding3.dart';
import 'package:tinkerly/screens/Starting/splashScreen.dart';
import 'package:tinkerly/screens/auth/login.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
  home: SignupPage(),
    );
  }
}
