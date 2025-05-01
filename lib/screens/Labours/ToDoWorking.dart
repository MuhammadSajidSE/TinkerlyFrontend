import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tinkerly/providers/userprovider.dart';
import 'package:tinkerly/screens/Labours/DetailTodoWork%20.dart';

class Todoworking extends StatefulWidget {
  const Todoworking({super.key});

  @override
  State<Todoworking> createState() => _TodoworkingState();
}

class _TodoworkingState extends State<Todoworking> {
  List<dynamic> allBookings = [];
  List<dynamic> filteredBookings = [];

  final TextEditingController _searchController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final token = user!.token;

    final response = await http.get(
      Uri.parse("http://150.136.5.153:2279/worker/bookings"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        allBookings = jsonResponse['data']
            .where((booking) => booking['status'] == 1) // Filter status == 1
            .toList();
        filteredBookings = allBookings; // Initial filter applied
      });
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredBookings = allBookings.where((booking) {
        final customer = booking['customerProfile']['userDetails'];
        final customerName = customer['name']?.toLowerCase() ?? '';
        final matchesName = customerName.contains(query);

        // Fix: Use startDate and parse it to DateTime
        final startDateStr = booking['startDate'];
        DateTime? bookingDate;
        try {
          bookingDate = DateTime.parse(startDateStr);
        } catch (_) {
          bookingDate = null;
        }

        // Only show bookings with status = 1
        final status = booking[
            'status']; // assuming 'status' is part of the booking object
        final matchesStatus = status == 1;

        // Only show bookings with status = 1 and matching name/date filter
        final matchesDate = selectedDate == null
            ? true
            : (bookingDate != null &&
                bookingDate.year == selectedDate!.year &&
                bookingDate.month == selectedDate!.month &&
                bookingDate.day == selectedDate!.day);

        return matchesName && matchesDate && matchesStatus;
      }).toList();
    });
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      _applyFilter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search and Date Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by customer name...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: _selectDate,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Booking List
          Expanded(
            child: filteredBookings.isEmpty
                ? const Center(child: Text('No bookings found'))
                : ListView.builder(
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      final customer = booking['customerProfile'];
                      final customerDetails = customer['userDetails'];
                      final avatarId = customer['avatarId'];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailTodoWork(
                                name: customerDetails['name'] ?? 'No Name',
                                description:
                                    booking['description'] ?? 'No Description',
                                address:
                                    customerDetails['address'] ?? 'No Address',
                                avatarId: avatarId,
                                startdate: booking["startDate"],
                                enddate: booking["endDate"],
                                workprice: booking["workPrice"],
                                worknameid: booking["workDetailsId"],
                                phonenumber: customerDetails["phone"],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: avatarId != null
                                      ? NetworkImage(
                                          "http://150.136.5.153:2280/cdn/$avatarId.png")
                                      : null,
                                  child: avatarId == null
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        customerDetails['name'] ?? 'No Name',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        booking['description'] ??
                                            'No Description',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        customerDetails['address'] ??
                                            'No Address',
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                    ],
                                  ),
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
}
