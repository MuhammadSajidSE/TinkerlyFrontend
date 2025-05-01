// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class MainCustomerController extends GetxController {
//   var selectedIndex = 0.obs;
//   var workDetails = [].obs;
//   var filteredWork = [].obs;
//   var isLoading = true.obs;
//   var selectedDomain = (-1).obs;
//   RxList<dynamic> pages = [].obs;
//   String? phone;

//   final List<Map<String, dynamic>> domains = [
//     {
//       'icon': 0xe57f, // Icons.carpenter.codePoint
//       'label': 'Carpentry',
//       'domain': 0,
//       "image": "assets/images/carpentry-min.jpg"
//     },
//     {
//       'icon': 0xe518, // Icons.lightbulb.codePoint
//       'label': 'Electrical',
//       'domain': 1,
//       "image": "assets/images/electrical-min.jpg"
//     },
//     {
//       'icon': 0xe40d, // Icons.plumbing.codePoint
//       'label': 'Plumbing',
//       'domain': 2,
//       "image": "assets/images/plumber-min.jpg"
//     },
//     {
//       'icon': 0xf1a8, // Icons.foundation.codePoint
//       'label': 'Masonry',
//       'domain': 3,
//       "image": "assets/images/masonry-min.jpg"
//     },
//     {
//       'icon': 0xe3c1, // Icons.construction.codePoint
//       'label': 'Welding',
//       'domain': 4,
//       "image": "assets/images/welding-min.jpg"
//     },
//     {
//       'icon': 0xe57f, // Icons.miscellaneous_services.codePoint
//       'label': 'Other',
//       'domain': 5,
//       "image": "assets/images/other-min.jpg"
//     }
//   ];

//   @override
//   void onInit() {
//     super.onInit();
//     fetchWorkDetails();
//     fetchContact();
//   }

//   Future<void> fetchContact() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     phone = prefs.getString("phone");
//   }

//   Future<void> fetchWorkDetails() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://150.136.5.153:2279/work/details'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['errored'] == false && data['data'] != null) {
//           workDetails.assignAll(data['data']);
//           filteredWork.assignAll(data['data']);
//           isLoading.value = false;
//         } else {
//           isLoading.value = false;
//           print('Error from API: ${data['errorMessage']}');
//         }
//       } else {
//         isLoading.value = false;
//         print('Failed to fetch data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       isLoading.value = false;
//       print('Exception during fetch: $e');
//     }
//   }

//   void filterWorkByDomain(int domain) {
//     selectedDomain.value = domain;
//     filteredWork.assignAll(
//       workDetails.where((item) => item['domain'] == domain).toList(),
//     );
//   }

//   void changeTab(int index) {
//     selectedIndex.value = index;
//   }
  
// }
