import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/screens/Authentication/login.dart';
import 'package:tinkerly/screens/Labours/HistoryWork.dart';
import 'package:tinkerly/screens/Labours/LabourProfile.dart';
import 'package:tinkerly/screens/Labours/ResponseWork.dart';
import 'package:tinkerly/screens/Labours/ToDoWorking.dart';
import 'package:tinkerly/screens/Labours/laborhome.dart';
// import 'package:tinkerly/screens/Labours/WorkTask.dart';
import 'package:tinkerly/screens/Labours/requestBooking.dart';

class Mainlabour extends StatefulWidget {
  const Mainlabour({super.key});

  @override
  State<Mainlabour> createState() => _MainlabourState();
}

class _MainlabourState extends State<Mainlabour> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Laborhome(),
    Responsework(),
    Todoworking(),
    WorkerRequestsPage(),
    Labourprofile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildDrawer() {
    final user = Provider.of<UserProvider>(context).user;

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? "Customer"),
            accountEmail: Text("Avatar ID: ${user?.avatarId ?? "N/A"}"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user != null
                  ? NetworkImage(
                      "http://150.136.5.153:2280/cdn/${user.avatarId}.png")
                  : null,
              child: user == null ? const Icon(Icons.person) : null,
            ),
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Chatting'),
            onTap: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           ContactsScreen(phone:user?.phone ?? "N/A")),
              // );
              // Handle navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('History Work'),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Historywork()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('UserToken');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
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
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work,
              color: Colors.black,
            ),
            label: 'Response',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.today_outlined,
              color: Colors.black,
            ),
            label: 'ToDo',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.call,
              color: Colors.black,
            ),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
