import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinkerly/firebase_options.dart';
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/screens/Authentication/laborSignup.dart';
import 'package:tinkerly/screens/Authentication/login.dart';
import 'package:tinkerly/screens/Authentication/mainSignup.dart';
import 'package:tinkerly/screens/Starting/onboarding3.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  home: Onboarding3Screen(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:tinkerly/screens/Authentication/login.dart';
// import 'package:tinkerly/screens/Chatting/contact.dart';
// import 'package:tinkerly/screens/Chatting/login.dart';
// import 'package:tinkerly/screens/Chatting/registerScreen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   runApp(MyApp());
// }

// // // Handle notification when the app is in the background
// // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   print("Notification Received: ${message.notification?.title}");
// // }

// class MyApp extends StatelessWidget {
//   Future<Widget> _getInitialScreen() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? phone = prefs.getString("phone");

//     if (phone != null && phone.isNotEmpty) {
//       return ContactsScreen(phone: phone);
//     } else {
//       return RegisterScreen();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FutureBuilder<Widget>(
//         future: _getInitialScreen(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return snapshot.data ?? ChatLoginScreen();
//         },
//       ),
//     );
//   }
// }
