import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/reusable_components/constants.dart';
import 'package:tinkerly/screens/Authentication/login.dart';
import 'package:tinkerly/screens/Chatting/contact.dart';
import 'package:tinkerly/screens/Customers/HistoryBooked.dart';
import 'package:tinkerly/screens/Labours/HistoryWork.dart';
import 'package:tinkerly/screens/Labours/LabourProfile.dart';
import 'package:tinkerly/screens/Labours/ToDoWorking.dart';
import 'package:tinkerly/screens/Labours/WorkTask.dart';
import 'package:tinkerly/screens/Labours/requestBooking.dart';

class Mainlabour extends StatefulWidget {
  const Mainlabour({super.key});

  @override
  State<Mainlabour> createState() => _MainlabourState();
}

class _MainlabourState extends State<Mainlabour> {
  int _selectedIndex = 0;
  final _advancedDrawerController = AdvancedDrawerController();
  final List<Widget> _pages = [
    Worktask(),
    Historywork(),
    Todoworking(),
    WorkerRequestsPage(),
    Labourprofile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Widget buildDrawer() {
  //   final user = Provider.of<UserProvider>(context).user;

  //   return Drawer(
  //     backgroundColor: const Color(0xFF2B557D),
  //     child: SafeArea(
  //       child: ListTileTheme(
  //         textColor: Colors.white,
  //       iconColor: Color(0xFFFFD700),
  //         child: ListView(
  //           children: [
  //             UserAccountsDrawerHeader(
  //               accountName: Text(user?.name ?? "Customer"),
  //               accountEmail: Text("Avatar ID: ${user?.avatarId ?? "N/A"}"),
  //               currentAccountPicture: CircleAvatar(
  //                 backgroundImage: user != null
  //                     ? NetworkImage(
  //                         "http://150.136.5.153:2280/cdn/${user.avatarId}.png")
  //                     : null,
  //                 child: user == null ? const Icon(Icons.person) : null,
  //               ),
  //               decoration: const BoxDecoration(color: Colors.blue),
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.settings),
  //               title: const Text('Settings'),
  //               onTap: () => Navigator.pop(context),
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.info),
  //               title: const Text('About'),
  //               onTap: () => Navigator.pop(context),
  //             ),
  //             ListTile(
  //               leading: Icon(Icons.info),
  //               title: Text('Chatting'),
  //               onTap: () {
  //                 // Navigator.pushReplacement(
  //                 //   context,
  //                 //   MaterialPageRoute(
  //                 //       builder: (context) =>
  //                 //           ContactsScreen(phone:user?.phone ?? "N/A")),
  //                 // );
  //                 // Handle navigation
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.logout),
  //               title: const Text('LogOut'),
  //               onTap: () async {
  //                 SharedPreferences prefs = await SharedPreferences.getInstance();
  //                 await prefs.remove('UserToken');
  //                 Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => LoginScreen()),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
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
                      builder: (context) =>
                          ContactsScreen(phone: user?.phone ?? "N/A"),
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
                    MaterialPageRoute(
                        builder: (context) => WorkerHistoryScreen()),
                  );
                },
                leading: const Icon(Icons.history),
                title: const Text('History'),
              ),
              ListTile(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
          body: Stack(
            children: [
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
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: SafeArea(child: _pages[_selectedIndex])),
            ],
          ),
          bottomNavigationBar: CurvedNavigationBar(
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
                label: 'Working', labelStyle: TextStyle(color: Colors.white), 
              ),
              CurvedNavigationBarItem(
                child: Icon(
                  Icons.today_outlined,
                  color: Colors.white,
                ),
                label: 'ToDo', labelStyle: TextStyle(color: Colors.white), 
              ),
              CurvedNavigationBarItem(
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                label: 'Request', labelStyle: TextStyle(color: Colors.white),
              ),
              CurvedNavigationBarItem(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: 'Profile', labelStyle: TextStyle(color: Colors.white), 
              ),
            ],
          ),
        ));
  }
}
