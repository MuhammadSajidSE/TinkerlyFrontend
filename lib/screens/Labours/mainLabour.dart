import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinkerly/screens/Authentication/login.dart';
import 'package:tinkerly/screens/Labours/HistoryWork.dart';
import 'package:tinkerly/screens/Labours/LabourProfile.dart';
import 'package:tinkerly/screens/Labours/WorkTask.dart';

class Mainlabour extends StatefulWidget {
  const Mainlabour({super.key});

  @override
  State<Mainlabour> createState() => _MainlabourState();
}

class _MainlabourState extends State<Mainlabour> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Worktask(),
    Historywork(),
    Labourprofile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Labour",
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Handle navigation
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              // Handle navigation
            },
          ),
    //       ListTile(
    //         leading: Icon(Icons.info),
    //         title: Text('Chatting'),
    //         onTap: () {
    //           Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => ContactsScreen(phone: phone)),
    // );
    //           // Handle navigation
    //         },
    //       ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('LogOut'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('UserToken');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
              // Handle navigation
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Customer"),
      ),
      drawer: buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Working',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
