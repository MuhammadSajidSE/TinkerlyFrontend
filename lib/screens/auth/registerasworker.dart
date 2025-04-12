// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:tinkerly/reusable_components/constants.dart';
// import 'package:tinkerly/reusable_components/widgets.dart';
// import 'package:tinkerly/screens/auth/login.dart';
// class RegisterScreen2 extends StatefulWidget {
//   @override
//   _RegisterScreen2State createState() => _RegisterScreen2State();
// }

// class _RegisterScreen2State extends State<RegisterScreen2> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor, // Use the constant color
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 60),
//               IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
//               const SizedBox(height: 10),
//               Text(
//                 'Jôbizz',
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primaryColor, // Use the primary color
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Registration as Worker 👍',
//                 style: GoogleFonts.poppins(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 "Let's Register. Apply to jobs!",
//                 style: GoogleFonts.poppins(fontSize: 14, color: AppColors.secondaryColor),
//               ),
//               const SizedBox(height: 20),
//               BuildTextFeild(icon: Icons.person, hintText: "Enter Full Name"),
//               BuildTextFeild(icon: Icons.email, hintText: "Enter E-mail"),
//               BuildTextFeild(icon: Icons.lock, hintText: "Enter Password", isPassword: true),
//               BuildTextFeild(icon: Icons.lock, hintText: "Confirm Password", isPassword: true),
             
//               const SizedBox(height: 20),
//               LoginRegisterButton(text: "Register", onPressed: (){}),
//               const SizedBox(height: 30),
//                Row(
//                 children: [
//                   Expanded(child: Divider(color: Colors.grey)),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       'Or continue with',
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Expanded(child: Divider(color: AppColors.dividerColor)),
//                 ],
//               ),
//               const SizedBox(height: 25),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   buildSocialButton(FontAwesomeIcons.apple),
//                   const SizedBox(width: 20),
//                   buildSocialButton(FontAwesomeIcons.google),
//                   const SizedBox(width: 20),
//                   buildSocialButton(FontAwesomeIcons.facebook),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//                   },
//                   child: RichText(
//                     text: TextSpan(
//                       text: 'Haven’t an account? ',
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         color: AppColors.secondaryColor, // Use secondary color constant
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'Login',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColors.primaryColor, // Use primary color constant
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
