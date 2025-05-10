// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart'; // For date formatting
// import 'package:provider/provider.dart';
// import 'package:tinkerly/providers/userprovider.dart';
// // import 'user_provider.dart'; // Assuming you have a provider for user

// class AcceptWork extends StatefulWidget {
//   final String name;
//   final String avatarId;
//   final String address;
//   final String phone;
//   final String description;
//   final String requestId;
//   final String workDetailsId;

//   const AcceptWork({
//     required this.name,
//     required this.avatarId,
//     required this.address,
//     required this.phone,
//     required this.description,
//     required this.requestId,
//     required this.workDetailsId,
//   });

//   @override
//   _AcceptWorkState createState() => _AcceptWorkState();
// }

// class _AcceptWorkState extends State<AcceptWork> {
//   String? workName;
//   DateTime? selectedDate;
//   TimeOfDay? startTime;
//   TimeOfDay? endTime;
//   int cost = 0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchWorkName();
//   }

//   Future<void> _fetchWorkName() async {
//     final response = await http.get(Uri.parse('http://150.136.5.153:2279/work/details'));

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       if (!data['errored']) {
//         List workDetails = data['data'];
//         for (var work in workDetails) {
//           if (work['id'] == widget.workDetailsId) {
//             setState(() {
//               workName = work['type'];
//             });
//             break;
//           }
//         }
//       } else {
//         // Handle error if needed
//         print('Error fetching data: ${data['errorMessage']}');
//       }
//     } else {
//       // Handle HTTP error if needed
//       print('Failed to load work details');
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context, bool isStartTime) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStartTime) {
//           startTime = picked;
//         } else {
//           endTime = picked;
//         }
//       });
//     }
//   }

//   Future<void> _submitData() async {
//     if (selectedDate == null || startTime == null || endTime == null || cost <= 0) {
//       // Show an error if required fields are missing
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: Text("Error"),
//           content: Text("Please fill all fields correctly."),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text("OK"),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     final user = Provider.of<UserProvider>(context, listen: false).user;
//     String usertoken = user!.token;

//     final startDate = DateTime(
//       selectedDate!.year,
//       selectedDate!.month,
//       selectedDate!.day,
//       startTime!.hour,
//       startTime!.minute,
//     ).toIso8601String();

//     final endDate = DateTime(
//       selectedDate!.year,
//       selectedDate!.month,
//       selectedDate!.day,
//       endTime!.hour,
//       endTime!.minute,
//     ).toIso8601String();

//     final response = await http.post(
//       Uri.parse('http://150.136.5.153:2279/work/create/response'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $usertoken',
//       },
//       body: json.encode({
//         'workRequestId': widget.requestId,
//         'startDate': startDate,
//         'endDate': endDate,
//         'cost': cost,
//         'status': 0,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Handle success response
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: Text("Success"),
//           content: Text("Work accepted successfully."),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text("OK"),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Handle failure response
//       print('Failed to accept work');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Accept Work'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Circular Image at the top
//               Center(
//                 child: CircleAvatar(
//                   radius: 50, // Adjust the size of the avatar
//                   backgroundImage: NetworkImage('http://150.136.5.153:2280/cdn/${widget.avatarId}.png'),
//                 ),
//               ),
//               const SizedBox(height: 16), // Space between image and text
        
//               // Display the work name if available
//               if (workName != null)
//                 Text('Work Name: $workName', style: TextStyle(fontSize: 18)),
        
//               const SizedBox(height: 16), // Space between work name and other details
//               Text('Name: ${widget.name}', style: TextStyle(fontSize: 18)),
//               Text('Address: ${widget.address}', style: TextStyle(fontSize: 18)),
//               Text('Phone: ${widget.phone}', style: TextStyle(fontSize: 18)),
//               Text('Description: ${widget.description}', style: TextStyle(fontSize: 18)),
//               // Text('Request ID: ${widget.requestId}', style: TextStyle(fontSize: 18)),
//               // Text('Work Details ID: ${widget.workDetailsId}', style: TextStyle(fontSize: 18)),
        
//               const SizedBox(height: 16),
        
//               // Date Picker
//               Text('Select Date:', style: TextStyle(fontSize: 18)),
//               ListTile(
//                 title: Text(selectedDate != null
//                     ? DateFormat.yMd().format(selectedDate!)
//                     : 'Select Date'),
//                 trailing: Icon(Icons.calendar_today),
//                 onTap: () => _selectDate(context),
//               ),
//               const SizedBox(height: 16),
        
//               // Start Time Picker
//               Text('Start Time:', style: TextStyle(fontSize: 18)),
//               ListTile(
//                 title: Text(startTime != null ? startTime!.format(context) : 'Select Start Time'),
//                 trailing: Icon(Icons.access_time),
//                 onTap: () => _selectTime(context, true),
//               ),
//               const SizedBox(height: 16),
        
//               // End Time Picker
//               Text('End Time:', style: TextStyle(fontSize: 18)),
//               ListTile(
//                 title: Text(endTime != null ? endTime!.format(context) : 'Select End Time'),
//                 trailing: Icon(Icons.access_time),
//                 onTap: () => _selectTime(context, false),
//               ),
//               const SizedBox(height: 16),
        
//               // Cost Input
//               TextField(
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(labelText: 'Cost'),
//                 onChanged: (value) {
//                   setState(() {
//                     cost = int.tryParse(value) ?? 0;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
        
//               // Confirm button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _submitData,
//                   child: const Text('Confirm'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/reusable_components/constants.dart'; // Import your constants file

class AcceptWork extends StatefulWidget {
  final String name;
  final String avatarId;
  final String address;
  final String phone;
  final String description;
  final String requestId;
  final String workDetailsId;

  const AcceptWork({
    super.key,
    required this.name,
    required this.avatarId,
    required this.address,
    required this.phone,
    required this.description,
    required this.requestId,
    required this.workDetailsId,
  });

  @override
  _AcceptWorkState createState() => _AcceptWorkState();
}

class _AcceptWorkState extends State<AcceptWork> {
  String? workName;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int cost = 0;
  final _formKey = GlobalKey<FormState>(); // Add a form key

  @override
  void initState() {
    super.initState();
    _fetchWorkName();
  }

  Future<void> _fetchWorkName() async {
    final response =
        await http.get(Uri.parse('http://150.136.5.153:2279/work/details'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (!data['errored']) {
        List workDetails = data['data'];
        for (var work in workDetails) {
          if (work['id'] == widget.workDetailsId) {
            setState(() {
              workName = work['type'];
            });
            break;
          }
        }
      } else {
        // Handle error if needed
        print('Error fetching data: ${data['errorMessage']}');
      }
    } else {
      // Handle HTTP error if needed
      print('Failed to load work details');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) { //Added builder to change the background color of the date picker
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryColor, // Header background color
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue, // Overall theme color
              accentColor: AppColors.primaryColor, // Selected date color
            ),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) { //Added builder to change the background color
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryColor, // Header background
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: AppColors.primaryColor, // Selected time color
            ),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) { // Use form validation
      if (selectedDate == null || startTime == null || endTime == null || cost <= 0) {
        return; //The form validation will handle the error message
      }

      final user = Provider.of<UserProvider>(context, listen: false).user;
      String usertoken = user!.token;

      final startDate = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        startTime!.hour,
        startTime!.minute,
      ).toIso8601String();

      final endDate = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        endTime!.hour,
        endTime!.minute,
      ).toIso8601String();

      final response = await http.post(
        Uri.parse('http://150.136.5.153:2279/work/create/response'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $usertoken',
        },
        body: json.encode({
          'workRequestId': widget.requestId,
          'startDate': startDate,
          'endDate': endDate,
          'cost': cost,
          'status': 0,
        }),
      );

      if (response.statusCode == 200) {
        // Handle success response
        _showSuccessDialog();
      } else {
        // Handle failure response
        _showErrorDialog('Failed to accept work. Please try again.'); // Show user friendly message
        print('Failed to accept work');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Work accepted successfully."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) { //show error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor, //Set the background color of the appbar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Accept Work', style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.w900)), //Set the title color
        backgroundColor: Colors.transparent, //Set the background color of the appbar
        elevation: 0, //Remove the shadow
        iconTheme: const IconThemeData(color: AppColors.primaryColor), //Change the color of the back button
      ),
      body: Stack(
        children: [Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/design.png',
              // height: 250, // make it big
              width: 136, // control width
              fit: BoxFit.contain,
            ),
          ),

          // Your main page content
          Container(
            padding:
                const EdgeInsets.only(top: 10), // Push down to avoid overlap
            
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0), //Increased padding for better spacing
                  child: Form(  //Wrap the column with a form
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Circular Image at the top
                        Center(
                          child: Container( //Added container to style the avatar
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2), // Reduced opacity
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: const Offset(0, 2), // Slightly adjusted offset
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage('http://150.136.5.153:2280/cdn/${widget.avatarId}.png'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(widget.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor, // Consistent color
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        _buildDetailText('Work Name:', workName ?? 'Loading...',), //Show loading..
                        const SizedBox(height: 12),
                        _buildDetailText('Address:', widget.address),
                        const SizedBox(height: 12),
                        _buildDetailText('Phone:', widget.phone),
                        const SizedBox(height: 12),
                        _buildDetailText('Description:', widget.description),
                        const SizedBox(height: 25),
              
                        // Date Picker
                        Text('Select Date:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.primaryColor)), //Added style
                        const SizedBox(height: 8),
                        ListTile(
                          tileColor: Colors.white, //Added color to the listtile
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), //Added rounded border
                          title: Text(selectedDate != null
                              ? DateFormat.yMd().format(selectedDate!)
                              : 'Select Date',
                              style: TextStyle(color: selectedDate == null ? Colors.grey : Colors.black) //Added color change
                              ),
                          trailing: const Icon(Icons.calendar_today, color: AppColors.primaryColor), //Consistent color
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 18),
              
                        // Start Time Picker
                        Text('Start Time:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.primaryColor)),
                        const SizedBox(height: 8),
                        ListTile(
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          title: Text(startTime != null ? startTime!.format(context) : 'Select Start Time',
                              style: TextStyle(color: startTime == null ? Colors.grey : Colors.black)),
                          trailing: const Icon(Icons.access_time, color: AppColors.primaryColor),
                          onTap: () => _selectTime(context, true),
                        ),
                        const SizedBox(height: 18),
              
                        // End Time Picker
                        Text('End Time:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.primaryColor)),
                        const SizedBox(height: 8),
                        ListTile(
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          title: Text(endTime != null ? endTime!.format(context) : 'Select End Time',
                              style: TextStyle(color: endTime == null ? Colors.grey: Colors.black)),
                          trailing: const Icon(Icons.access_time, color: AppColors.primaryColor),
                          onTap: () => _selectTime(context, false),
                        ),
                        const SizedBox(height: 18),
              
                        // Cost Input
                        Text('Cost:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.primaryColor)),
                        const SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cost',
                            labelStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none, // Remove the border
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the cost';
                            }
                            if (int.tryParse(value) == null || int.parse(value) <= 0) {
                              return 'Invalid cost';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              cost = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
              
                        // Confirm button
                        Center(
                          child: ElevatedButton(
                            onPressed: _submitData,
                            style: ElevatedButton.styleFrom( //Added style to the button
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              shadowColor: AppColors.primaryColor.withOpacity(0.4),
                            ),
                            child: const Text('Confirm', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for consistent text styling
  Widget _buildDetailText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 18, color: Colors.black87), // Default text color
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.primaryColor), // Bold label, primary color
          ),
          TextSpan(text: ' $value'),
        ],
      ),
    );
  }
}

