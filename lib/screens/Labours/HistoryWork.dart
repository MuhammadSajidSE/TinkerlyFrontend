import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Historywork extends StatefulWidget {
  const Historywork({super.key});

  @override
  State<Historywork> createState() => _HistoryworkState();
}

class _HistoryworkState extends State<Historywork> {
  List allData = [];
  List filteredData = [];
  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  // Fetch work history data from API
  Future<void> fetchHistory() async {
    try {
      final response = await http.get(Uri.parse('http://150.136.5.153:2279/worker/history'));

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List data = jsonBody['data'];

        setState(() {
          allData = data;
          filteredData = data; // show all work by default
        });
      } else {
        throw Exception('Failed to load history data');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // Filter work history by selected month
  void filterByMonth(DateTime date) {
    setState(() {
      selectedMonth = date;
      filteredData = allData.where((item) {
        DateTime start = DateTime.parse(item['startDate']);
        return start.year == date.year && start.month == date.month;
      }).toList();
    });
  }

  // Show month picker dialog
  void showMonthPicker() {
    showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select Month',
    ).then((selectedDate) {
      if (selectedDate != null) {
        filterByMonth(DateTime(selectedDate.year, selectedDate.month));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: showMonthPicker,
          ),
        ],
      ),
      body: Column(
        children: [
          if (filteredData.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No work history found for the selected month.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          if (filteredData.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final work = filteredData[index];
                  final customer = work['customerProfile']['userDetails'];
                  final workerName = work['description'];
                  final workPrice = work['workPrice'];
                  final startDate = DateTime.parse(work['startDate']);
                  final endDate = DateTime.parse(work['endDate']);
                  final avatarId = work['customerProfile']['avatarId'];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: avatarId != null
                            ? NetworkImage("http://150.136.5.153:2280/cdn/$avatarId.png")
                            : null,
                        child: avatarId == null ? const Icon(Icons.person) : null,
                      ),
                      title: Text(customer['name'] ?? 'No name'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(' $workerName'),
                        ],
                      ),
                      trailing:                           Text('Price: \$${workPrice.toString()}'),
                    ),
                  );
                },
              ),
            ),

          if (filteredData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Price: \$${filteredData.fold<double>(0.0, (sum, item) => sum + (item['workPrice'] as num).toDouble()).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
