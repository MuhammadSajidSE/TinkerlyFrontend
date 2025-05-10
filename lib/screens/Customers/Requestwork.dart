// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'dart:convert';

// import 'package:tinkerly/providers/userprovider.dart';
// import 'package:tinkerly/reusable_components/constants.dart';

// class CustomerRequestWork extends StatefulWidget {
//   const CustomerRequestWork({super.key});

//   @override
//   State<CustomerRequestWork> createState() => _CustomerRequestWorkState();
// }

// class _CustomerRequestWorkState extends State<CustomerRequestWork> {
//   List<dynamic> requestData = [];
//   bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final user = Provider.of<UserProvider>(context, listen: false).user;
//     String userToken = user!.token;

//     final url = Uri.parse('http://150.136.5.153:2279/customer/requests');

//     final response = await http.get(
//       url,
//       headers: {'Authorization': 'Bearer $userToken'},
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       setState(() {
//         requestData = data['data']
//             .where(
//                 (request) => request['status'] == 0 || request['status'] == 1)
//             .toList().reversed.toList(); // Filter for status 0 or 1

//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       print('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: Text(
//           'Customer Request Work',
//           style: TextStyle(
//               fontSize: 22,
//               color: AppColors.primaryColor,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : requestData.isEmpty
//               ? Center(
//                   child: Text(
//                     'No work on pending',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: requestData.length,
//                   itemBuilder: (context, index) {
//                     var request = requestData[index];
//                     var avatarId = request['worker']['avatarId'];
//                     var workerName = request['worker']['userDetails']['name'];
//                     var description = request['description'];
//                     var status = request['status'];

//                     // Define colors based on status
//                     Color borderColor =
//                         status == 1 ? Colors.amber : Colors.amber;

//                     Color backgroundColor = status == 1
//                         ? AppColors.secondaryColor
//                         : AppColors.primaryColor;

//                     return Container(
//                       margin: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                           color: backgroundColor, // light red / light green
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: borderColor, // dark red / dark green
//                             width: 0.5,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: status == 1
//                                   ? AppColors.secondaryColor
//                                   : AppColors.primaryColor,
//                               spreadRadius: 1,
//                               blurRadius: 5,
//                               offset:
//                                   Offset(0, 1), // changes position of shadow
//                             )
//                           ]),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           radius: 25,
//                           backgroundColor: Colors.amber,
//                           child: CircleAvatar(
//                             radius: 23,
//                             backgroundImage: avatarId != null
//                                 ? NetworkImage(
//                                     "http://150.136.5.153:2280/cdn/$avatarId.png",
//                                   )
//                                 : null,
//                             child: avatarId == null
//                                 ? const Icon(Icons.person)
//                                 : null,
//                           ),
//                         ),
//                         title: Text(
//                           workerName,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: status == 1
//                                   ? AppColors.primaryColor
//                                   : AppColors.secondaryColor),
//                         ),
//                         subtitle: Text(
//                           description,
//                           style: TextStyle(
//                               color: status == 1
//                                   ? AppColors.primaryColor
//                                   : AppColors.secondaryColor),
//                         ),
//                         trailing: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 14, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: status == 1
//                                 ? const Color.fromARGB(255, 206, 54, 54)
//                                 : const Color.fromARGB(
//                                     255, 84, 158, 0), // RED if 1, GREEN if 0
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             status == 1
//                                 ? 'Rejected'
//                                 : 'Pending', // Text also matches
//                             style: TextStyle(
//                               color: status != 1
//                                   ? Colors.white
//                                   : AppColors
//                                       .backgroundColor, // Always black text (clear for both backgrounds)
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart.dart';
import 'dart:convert';
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/reusable_components/constants.dart';

class CustomerRequestWork extends StatefulWidget {
  const CustomerRequestWork({super.key});

  @override
  _CustomerRequestWorkState createState() => _CustomerRequestWorkState();
}

class _CustomerRequestWorkState extends State<CustomerRequestWork>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> allRequests = [];
  List<dynamic> pendingRequests = [];
  List<dynamic> rejectedRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    if (!mounted) return;

    final user = Provider.of<UserProvider>(context, listen: false).user;
    String userToken = user!.token;

    final url = Uri.parse('http://150.136.5.153:2279/customer/requests');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $userToken'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> fetchedRequests = data['data'];

      if (!mounted) return;

      setState(() {
        allRequests = fetchedRequests.reversed.toList();
        pendingRequests = fetchedRequests
            .where((request) => request['status'] == 0)
            .toList()
            .reversed
            .toList();
        rejectedRequests = fetchedRequests
            .where((request) => request['status'] == 1)
            .toList()
            .reversed
            .toList();
        isLoading = false;
      });
    } else {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Customer Requests',
          style: TextStyle(
            fontSize: 22,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.secondaryColor,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            top: 100, // Height of the TabBar is 100.
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRequestList(allRequests, -1),
                      _buildRequestList(pendingRequests, 0),
                      _buildRequestList(rejectedRequests, 1),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<dynamic> requests, int status) {
    if (requests.isEmpty) {
      return Center(
        child: Text(
          'No ${status == -1 ? 'requests' : status == 0 ? 'pending' : 'rejected'} requests.',
          style: const TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 0), // Remove top padding of listview
      itemCount: requests.length,
      itemBuilder: (context, index) {
        var request = requests[index];
        var avatarId = request['worker']['avatarId'];
        var workerName = request['worker']['userDetails']['name'];
        var description = request['description'];
        var requestStatus = request['status'];

        Color borderColor;
        Color backgroundColor;

        if (status == -1) {
          borderColor =
              requestStatus == 1 ? Colors.amber : Colors.amber;
          backgroundColor = requestStatus == 1
              ? AppColors.secondaryColor
              : AppColors.primaryColor;
        } else {
          borderColor = status == 1 ? Colors.amber : Colors.amber;
          backgroundColor =
              status == 1 ? AppColors.secondaryColor : AppColors.primaryColor;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: status == -1
                    ? AppColors.primaryColor.withOpacity(0.2)
                    : status == 1
                        ? AppColors.secondaryColor.withOpacity(0.2)
                        : AppColors.primaryColor.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.amber,
              child: CircleAvatar(
                radius: 23,
                backgroundImage: avatarId != null
                    ? NetworkImage(
                        "http://150.136.5.153:2280/cdn/$avatarId.png",
                      )
                    : null,
                child: avatarId == null ? const Icon(Icons.person) : null,
              ),
            ),
            title: Text(
              workerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status == -1
                    ? requestStatus == 1
                        ? AppColors.primaryColor
                        : AppColors.secondaryColor
                    : status == 1
                        ? AppColors.primaryColor
                        : AppColors.secondaryColor,
              ),
            ),
            subtitle: Text(
              description,
              style: TextStyle(
                color: status == -1
                    ? requestStatus == 1
                        ? AppColors.primaryColor
                        : AppColors.secondaryColor
                    : status == 1
                        ? AppColors.primaryColor
                        : AppColors.secondaryColor,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: status == -1
                    ? requestStatus == 1
                        ? const Color.fromARGB(255, 206, 54, 54)
                        : const Color.fromARGB(255, 84, 158, 0)
                    : status == 1
                        ? const Color.fromARGB(255, 206, 54, 54)
                        : const Color.fromARGB(255, 84, 158, 0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status == -1
                    ? requestStatus == 1
                        ? 'Rejected'
                        : 'Pending'
                    : status == 1
                        ? 'Rejected'
                        : 'Pending',
                style: TextStyle(
                    color: status == -1
                        ? Colors.white
                        : AppColors
                            .backgroundColor, //  consistent text color
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}

