// // login_screen.dart

// import 'package:flutter/material.dart';
// import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
// import 'package:tinkerly/reusable_components/constants.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tinkerly/reusable_components/widgets.dart';
// import 'package:tinkerly/screens/auth/registerasuser.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor, // Use background color constant
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
//                   color: AppColors.primaryColor, // Use primary color constant
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Welcome Back 👋',
//                 style: GoogleFonts.poppins(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 "Let’s log in. Apply to jobs!",
//                 style: GoogleFonts.poppins(fontSize: 14, color: AppColors.secondaryColor), // Use secondary color constant
//               ),
//               const SizedBox(height: 45),
//               BuildTextFeild(icon: Icons.email, hintText: "Enter E-mail"),
//               BuildTextFeild(icon: Icons.lock, hintText: "Enter Password", isPassword: true),
             
//               const SizedBox(height: 20),
//               LoginRegisterButton(text: "Login", onPressed: () {}),
//               const SizedBox(height: 20),
//               Center(
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: Text(
//                     'Forgot Password?',
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       color: AppColors.primaryColor, // Use primary color constant
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//               Row(
//                 children: [
//                   Expanded(child: Divider(color: AppColors.dividerColor)), // Use divider color constant
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       'Or continue with',
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         color: AppColors.secondaryColor, // Use secondary color constant
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Expanded(child: Divider(color: AppColors.dividerColor)), // Use divider color constant
//                 ],
//               ),
//               const SizedBox(height: 30),
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
//               const SizedBox(height: 40),
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
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
//                           text: 'Register',
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
