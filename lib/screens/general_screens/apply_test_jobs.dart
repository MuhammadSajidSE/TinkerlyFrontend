import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinkerly/reusable_components/constants.dart';
import 'package:tinkerly/reusable_components/widgets.dart';

class ApplyTestJobs extends StatefulWidget {
  const ApplyTestJobs({super.key});

  @override
  State<ApplyTestJobs> createState() => _ApplyTestJobsState();
}

class _ApplyTestJobsState extends State<ApplyTestJobs> {
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
          Image.asset('assets/images/applyjob.png', height: 300),

          SizedBox(height: 30),

          // Title
          Text(
            "Apply to best jobs",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.blackcolor,
            ),
          ),

          SizedBox(height: 10),

          // Subtitle
          
         
          CustomTextWidget(text: "You can apply to your desirable jobs very quickly and easily with ease." ),

          SizedBox(height: 20),

          // Existing Page Indicator (Blue Slider)
         BlueSlider(),
          SizedBox(height: 20),

          // Buttons Row
        NextSkipButton(onNextPressed: (){

          }, onSkipPressed:(){

          } ),
          Spacer(),

         

BlackSlider(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}