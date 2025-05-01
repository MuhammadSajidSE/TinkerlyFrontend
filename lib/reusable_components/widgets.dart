import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinkerly/reusable_components/constants.dart';

//General Widgets

class CustomTextWidget extends StatelessWidget {
  final String text;

  const CustomTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }
}



// Import AppColors for button color

class NextSkipButton extends StatefulWidget {
  final VoidCallback onNextPressed;
  final VoidCallback onSkipPressed;

  const NextSkipButton({
    Key? key,
    required this.onNextPressed,
    required this.onSkipPressed,
  }) : super(key: key);

  @override
  _NextSkipButtonState createState() => _NextSkipButtonState();
}

class _NextSkipButtonState extends State<NextSkipButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: widget.onNextPressed, // Access the onNextPressed callback
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            foregroundColor: Colors.white,
            backgroundColor: AppColors.buttoncolor, // Dark blue color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Increase button size
          ),
          child: Text("Next"),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: widget.onSkipPressed, // Access the onSkipPressed callback
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey, // Grey color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Increase button size
          ),
          child: Text("Skip"),
        ),
      ],
    );
  }
}


// Import AppColors for button color

class ExploreButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ExploreButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  _ExploreButtonState createState() => _ExploreButtonState();
}

class _ExploreButtonState extends State<ExploreButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed, // Use widget.onPressed to access the passed callback
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.buttoncolor, // Dark blue color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        padding: EdgeInsets.only(left: 120, right: 120, top: 20, bottom: 20), // Increase button size
      ),
      child: Text("Explore"),
    );
  }
}

class BlackSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: index == 0 ? 60 : 20,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.blackcolor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}


class BlueSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: index == 0 ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == 0 ? AppColors.blueslider : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}


//RegisterScreen Widgets


class BuildTextFeild extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;

  const BuildTextFeild({
    Key? key,
    required this.icon,
    required this.hintText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _BuildTextFeildState createState() => _BuildTextFeildState();
}

class _BuildTextFeildState extends State<BuildTextFeild> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: Colors.grey),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          filled: true,
          fillColor: AppColors.whitecolor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}




  Widget buildSocialButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.whitecolor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: IconButton(
        icon: FaIcon(icon, color: Colors.black),
        onPressed: () {},
      ),
    );
  }


class LoginRegisterButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;

  const LoginRegisterButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  _LoginRegisterButtonState createState() => _LoginRegisterButtonState();
}

class _LoginRegisterButtonState extends State<LoginRegisterButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 50,
      child: ElevatedButton(
        onPressed: widget.onPressed, // Use widget.onPressed to access the callback
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttoncolor, // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ),
        child: Text(
          widget.text, // Use widget.text to access the text property
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}