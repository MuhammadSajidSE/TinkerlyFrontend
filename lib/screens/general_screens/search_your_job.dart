import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinkerly/reusable_components/constants.dart';
import 'package:tinkerly/reusable_components/widgets.dart';

class SearchYourJob extends StatefulWidget {
  const SearchYourJob({super.key});

  @override
  State<SearchYourJob> createState() => _SearchYourJobState();
}

class _SearchYourJobState extends State<SearchYourJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
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
          Text(
            "Search your job",
         
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 10),

          // Subtitle
          CustomTextWidget(text: "Figure out your top five priorities whether it is company culture, salary."),

          SizedBox(height: 20),

          // Existing Page Indicator (Blue Slider)
        BlueSlider(),
          Spacer(),

          // New Black Slider
      BlackSlider(),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}