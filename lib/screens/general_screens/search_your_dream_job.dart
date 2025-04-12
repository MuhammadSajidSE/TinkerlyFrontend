import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinkerly/reusable_components/widgets.dart';

class SearchYourDreamJob extends StatefulWidget {
  const SearchYourDreamJob({super.key});

  @override
  State<SearchYourDreamJob> createState() => _SearchYourDreamJobState();
}

class _SearchYourDreamJobState extends State<SearchYourDreamJob> {
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
          Image.asset('assets/images/searchyourdreamjob.png', height: 300),

          SizedBox(height: 30),

         
           RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              children: [
                TextSpan(text: 'Search your dream\n'),
                TextSpan(text: 'job fast and ease'),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Subtitle
          CustomTextWidget(text: "Figure out your top five priorities whether it is company culture, salary or a specific job position. "),

          SizedBox(height: 20),

          // Existing Page Indicator (Blue Slider)
          BlueSlider(),

          SizedBox(height: 20),

          // Buttons Row
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