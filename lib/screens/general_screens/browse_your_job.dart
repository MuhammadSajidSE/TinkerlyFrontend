import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinkerly/reusable_components/constants.dart';
import 'package:tinkerly/reusable_components/widgets.dart';

class BrowseYourJob extends StatefulWidget {
  const BrowseYourJob({super.key});

  @override
  State<BrowseYourJob> createState() => _BrowseYourJobState();
}

class _BrowseYourJobState extends State<BrowseYourJob> {
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
          Image.asset('assets/images/browsejob.png', height: 300),

          SizedBox(height: 30),

          // Title
          Text(
            "Browse your job",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.blackcolor,
            ),
          ),

          SizedBox(height: 10),

          // Subtitle
         CustomTextWidget(text: "Our Job list include several industries,so you can find the best job for you."),

          SizedBox(height: 20),

          // Existing Page Indicator (Blue Slider)
        BlueSlider(),

          SizedBox(height: 20),

        

          NextSkipButton(onNextPressed: (){

          }, onSkipPressed:(){

          } ),

          Spacer(),

          // New Black Slider
        BlackSlider(),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}