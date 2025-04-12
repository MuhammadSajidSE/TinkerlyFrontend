import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinkerly/reusable_components/widgets.dart';

class MakeYourDreamJob extends StatefulWidget {
  const MakeYourDreamJob({super.key});

  @override
  State<MakeYourDreamJob> createState() => _MakeYourDreamJobState();
}

class _MakeYourDreamJobState extends State<MakeYourDreamJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top curved design
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(200),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          // SVG Image
          Image.asset('assets/images/searchyourjob.png', height: 300),

          SizedBox(height: 30),

          // Title
          // Text(
          //   "Make your dream career with job",
          //   style: GoogleFonts.poppins(
          //     fontSize: 22,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black87,
          //   ),
          // ),
              RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              children: [
                TextSpan(text: 'Make your dream\n'),
                TextSpan(text: 'career with job'),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Subtitle
       CustomTextWidget(text: "We help you find your dream job according to your skillset, location & preference to build your career."),

          SizedBox(height: 20),

          // Existing Page Indicator (Blue Slider)
        BlueSlider(),

          SizedBox(height: 20),

          // Buttons Row
         ExploreButton(onPressed:  () {}),

          Spacer(),

          // New Black Slider
         BlackSlider(),

          SizedBox(height: 20),
        ],
      ),
    );;
  }
}