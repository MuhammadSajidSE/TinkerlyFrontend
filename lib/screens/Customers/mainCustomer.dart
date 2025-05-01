import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'dart:convert';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/reusable_components/constants.dart';
import 'package:tinkerly/screens/Authentication/login.dart';
import 'package:tinkerly/screens/Chatting/contact.dart';
import 'package:tinkerly/screens/Chatting/login.dart';
import 'package:tinkerly/screens/Customers/HistoryBooked.dart';
import 'package:tinkerly/screens/Customers/ListOfBookedWork.dart';
import 'package:tinkerly/screens/Customers/Requestwork.dart';
import 'package:tinkerly/screens/Customers/ResponseWork.dart';
import 'package:tinkerly/screens/Customers/customerProfile.dart';
import 'package:tinkerly/screens/Customers/skill_detail.dart';

class MainCustomer extends StatefulWidget {
  const MainCustomer({super.key});

  @override
  _MainCustomerState createState() => _MainCustomerState();
}

class _MainCustomerState extends State<MainCustomer> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];
  List<dynamic> _workDetails = [];
  List<dynamic> _filteredWork = [];
  bool _isLoading = true;
  int _selectedDomain = -1;
  String? phone;

  final _advancedDrawerController = AdvancedDrawerController();

  final List<Map<String, dynamic>> _domains = [
    {
      'icon': Icons.carpenter,
      'label': 'Carpentry',
      'domain': 0,
      "image": "assets/images/carpentry-min.jpg"
    },
    {
      'icon': Icons.lightbulb,
      'label': 'Electrical',
      'domain': 1,
      "image": "assets/images/electrical-min.jpg"
    },
    {
      'icon': Icons.plumbing,
      'label': 'Plumbing',
      'domain': 2,
      "image": "assets/images/plumber-min.jpg"
    },
    {
      'icon': Icons.foundation,
      'label': 'Masonry',
      'domain': 3,
      "image": "assets/images/masonry-min.jpg"
    },
    {
      'icon': Icons.construction,
      'label': 'Welding',
      'domain': 4,
      "image": "assets/images/welding-min.jpg"
    },
    {
      'icon': Icons.miscellaneous_services,
      'label': 'Other',
      'domain': 5,
      "image": "assets/images/other-min.jpg"
    }
  ];

  @override
  void initState() {
    super.initState();
    fetchWorkDetails();
    fetchcontact();
  }

  Future<void> fetchcontact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString("phone");
  }

  Future<void> fetchWorkDetails() async {
    try {
      final response =
          await http.get(Uri.parse('http://150.136.5.153:2279/work/details'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['errored'] == false && data['data'] != null) {
          setState(() {
            _workDetails = data['data'];
            _filteredWork = data['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          debugPrint('Error from API: ${data['errorMessage']}');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        debugPrint('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Exception during fetch: $e');
    }
  }

  void filterWorkByDomain(int domain) {
    setState(() {
      _selectedDomain = domain;
      _filteredWork = _workDetails.where((item) {
        if (item['domain'] == null) {
          debugPrint('Found null domain in item: $item');
          return false;
        }
        return item['domain'] == domain;
      }).toList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserProvider>(context).user;
    _pages = [
      _homeScreen(user),
      const CustomerRequestWork(),
      const BookingListWidget(),
      const CustomerResponsework(),
      const Customerprofile(),
    ];
  }


Widget _homeScreen(user) {
  if (_isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Work Domains",
          style: TextStyle(
              fontSize: 22,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 0),
        SizedBox(
          height: 150,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _domains.map((domain) {
                final isSelected = _selectedDomain == domain['domain'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDomain = domain['domain'];
                      filterWorkByDomain(domain['domain']);
                    });
                  },
                  child: Container(
                    width: 240,
                    height: 130,
                    margin: const EdgeInsets.only(right: 12, left: 9),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(domain['image']),
                        opacity: 0.5,
                        fit: BoxFit.cover,
                      ),
                      color: isSelected ? Color(0xFF2B557D) : Color(0xFFced5df),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2B557D).withOpacity(0.4),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Color(0xFFced5df), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(domain['icon'],
                            size: 40,
                            color: isSelected ? Colors.white : Colors.black),
                        const SizedBox(height: 10),
                        Text(
                          domain['label'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Skills",
          style: TextStyle(
              fontSize: 20,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold),
        ),
        GridView.builder(
          itemCount: _filteredWork.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (context, index) {
            final item = _filteredWork[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SkillDetailScreen(skillId: item['id']),
                  ),
                );
              },
              child: Card(
                color: AppColors.secondaryColor,
                borderOnForeground: true,
                shadowColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: AppColors.primaryColor,
                    width: .5,
                  ),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.work,
                          size: 30, color: AppColors.primaryColor),
                      const SizedBox(height: 8),
                      Text(
                        item['type'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


Widget buildDrawer() {
  final user = Provider.of<UserProvider>(context).user;
  const Color golden = Color(0xFFFFD700);

  return Drawer(
    backgroundColor: const Color(0xFF2B557D),
    child: SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: golden,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 128.0,
              height: 128.0,
              margin: const EdgeInsets.only(top: 24.0, bottom: 8.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: user != null && user.avatarId != null
                  ? Image.network(
                      "http://150.136.5.153:2280/cdn/${user.avatarId}.png",
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person, size: 60, color: Colors.white),
            ),
            Text(
              user?.name ?? "Customer",
              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user?.isWorker == true ? "Worker" : "Customer",
              style: const TextStyle(fontSize: 14, color: Colors.white54),
            ),
            const SizedBox(height: 32),
            ListTile(
              onTap: () => Navigator.pop(context),
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            ListTile(
              onTap: () => Navigator.pop(context),
              leading: const Icon(Icons.info),
              title: const Text('About'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactsScreen(phone: user?.phone ?? "N/A"),
                  ),
                );
              },
              leading: const Icon(Icons.chat),
              title: const Text('Chatting'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerHistoryScreen()),
                );
              },
              leading: const Icon(Icons.history),
              title: const Text('History'),
            ),
            ListTile(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('UserToken');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Terms of Service | Privacy Policy',
                style: TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    _pages[0] = _homeScreen(user);
    const images = [AssetImage("assets/images/design.png")];

    return AdvancedDrawer(
    backdropColor: const Color(0xFF2B557D),
    controller: _advancedDrawerController,
    animationCurve: Curves.easeInOut,
    animationDuration: const Duration(milliseconds: 300),
    animateChildDecoration: true,
    rtlOpening: false,
    openScale: 0.85,
    openRatio: 0.75,
    disabledGestures: false,
    childDecoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    drawer: buildDrawer(), // your animated drawer UI
    child: Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(70),
      //   child: AppBar(
      //     // leading: Image(image: images[0]),
      //     title: const Text(
      //       'Tinkerly',
      //       style: TextStyle(
      //           fontSize: 30,
      //           fontWeight: FontWeight.bold,
      //           color: AppColors.primaryColor),
      //     ),
      //     centerTitle: true,
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //   ),
      // ),
      
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(70),
  child: AppBar(
    leading: IconButton(
      onPressed: () {
        _advancedDrawerController.showDrawer();
      },
      icon: ValueListenableBuilder<AdvancedDrawerValue>(
        valueListenable: _advancedDrawerController,
        builder: (_, value, __) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              value.visible ? Icons.clear : Icons.menu,
              key: ValueKey<bool>(value.visible),
              color: AppColors.primaryColor,
            ),
          );
        },
      ),
    ),
    title: const Text(
      'Tinkerly',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
),

      drawer: buildDrawer(),
      // body: _pages[_selectedIndex],
      body: Stack(
        children: [
          // Your top-right big image
          Positioned(
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
            child: 
           SafeArea(
  child: _pages[_selectedIndex],
),
          ),
        ],
      ),
     
      bottomNavigationBar: CurvedNavigationBar(
        //  key: _bottomNavigationKey,
        buttonBackgroundColor: AppColors.primaryColor,
        backgroundColor: Colors.transparent,
        color: AppColors.primaryColor,
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.easeInOut,
        index: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home', labelStyle: TextStyle(color: Colors.white), // Add this line
          ),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.work,
                color: Colors.white,
              ),
              label: 'Request',labelStyle: TextStyle(color: Colors.white),),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.book,
                color: Colors.white,
              ),
              label: 'Booked',labelStyle: TextStyle(color: Colors.white),),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.call,
                color: Colors.white,
              ),
              label: 'Response',labelStyle: TextStyle(color: Colors.white),),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: 'Profile',labelStyle: TextStyle(color: Colors.white),),
        ],
      ),
    ),
    );
  }
}
