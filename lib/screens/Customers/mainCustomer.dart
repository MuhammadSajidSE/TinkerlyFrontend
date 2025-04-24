import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/screens/Authentication/login.dart';
import 'package:tinkerly/screens/Chatting/contact.dart';
import 'package:tinkerly/screens/Chatting/login.dart';
import 'package:tinkerly/screens/Customers/Addwork.dart';
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

  final List<Map<String, dynamic>> _domains = [
    {'icon': Icons.carpenter, 'label': 'Carpentry', 'domain': 0},
    {'icon': Icons.lightbulb, 'label': 'Electrical', 'domain': 1},
    {'icon': Icons.plumbing, 'label': 'Plumbing', 'domain': 2},
    {'icon': Icons.foundation, 'label': 'Masonry', 'domain': 3},
    {'icon': Icons.construction, 'label': 'Welding', 'domain': 4},
    {'icon': Icons.miscellaneous_services, 'label': 'Other', 'domain': 5},
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
      const Addwork(),
      const Customerprofile(),
    ];
  }

  Widget _homeScreen(user) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Work Domains",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: _domains.map((domain) {
                final isSelected = _selectedDomain == domain['domain'];
                return GestureDetector(
                  onTap: () => filterWorkByDomain(domain['domain']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.shade300
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(domain['icon'], size: 30, color: Colors.blue),
                        const SizedBox(height: 5),
                        Text(
                          domain['label'],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Skills",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              itemCount: _filteredWork.length,
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
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.work, size: 30, color: Colors.blue),
                          const SizedBox(height: 8),
                          Text(item['type'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          SingleChildScrollView(
                            child: Text("Rs. ${item['recommendedPrice']}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ContactsScreen(phone:user?.phone ?? "N/A")),
              );
              // Handle navigation
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
    final user = Provider.of<UserProvider>(context).user;
    _pages[0] = _homeScreen(user);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          title: Row(
            children: [
              if (user != null)
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                      "http://150.136.5.153:2280/cdn/${user.avatarId}.png"),
                )
              else
                const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.person),
                ),
              const SizedBox(width: 10),
              const Text("Main Customer"),
            ],
          ),
        ),
      ),
      drawer: buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Working'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
