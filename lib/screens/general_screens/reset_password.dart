import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinkerly/reusable_components/constants.dart';
import 'package:tinkerly/reusable_components/widgets.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            Text(
              'Jôbizz',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Reset Password',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            CustomTextWidget(
              text:
                  "Enter your new password and confirm the new password to reset password",
            ),
            SizedBox(height: 70),
            BuildTextFeild(
              icon: Icons.lock,
              hintText: " New Password",
              isPassword: true,
            ),
            SizedBox(height: 10),
            BuildTextFeild(
              icon: Icons.lock,
              hintText: "Confirm New Password",
              isPassword: true,
            ),

            SizedBox(height: 60),
            LoginRegisterButton(text: "Reset Password", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
