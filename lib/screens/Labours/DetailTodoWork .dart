import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailTodoWork extends StatefulWidget {
  final String name;
  final String description;
  final String address;
  final String? avatarId;
  final String enddate;
  final String startdate;
  final double workprice;
  final String worknameid;
  final String phonenumber;

  const DetailTodoWork({
    super.key,
    required this.name,
    required this.description,
    required this.address,
    this.avatarId,
    required this.enddate,
    required this.startdate,
    required this.workprice,
    required this.worknameid,
    required this.phonenumber,
  });

  @override
  State<DetailTodoWork> createState() => _DetailTodoWorkState();
}

class _DetailTodoWorkState extends State<DetailTodoWork> {
  String workType = '';
  Duration? workingHours;
  late DateTime startDateTime;
  late DateTime endDateTime;

  late String startDateOnly;
  late String startTimeOnly;

  late String endDateOnly;
  late String endTimeOnly;

  @override
  void initState() {
    super.initState();
    startDateTime = DateTime.parse(widget.startdate);
    endDateTime = DateTime.parse(widget.enddate);

    startDateOnly = DateFormat('yyyy-MM-dd').format(startDateTime);
    startTimeOnly = DateFormat('hh:mm a').format(startDateTime);

    endDateOnly = DateFormat('yyyy-MM-dd').format(endDateTime);
    endTimeOnly = DateFormat('hh:mm a').format(endDateTime);

    fetchWorkType();
    calculateWorkingHours();
  }

  void calculateWorkingHours() {
    DateTime start = DateTime.parse(widget.startdate);
    DateTime end = DateTime.parse(widget.enddate);
    setState(() {
      workingHours = end.difference(start);
    });
  }

  Future<void> fetchWorkType() async {
    try {
      final response = await http.get(Uri.parse('http://150.136.5.153:2279/work/details'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final workList = data['data'] as List<dynamic>;

        final matchedWork = workList.firstWhere(
          (element) => element['id'] == widget.worknameid,
          orElse: () => null,
        );

        if (matchedWork != null) {
          setState(() {
            workType = matchedWork['type'];
          });
        }
      } else {
        print('Failed to load work details');
      }
    } catch (e) {
      print('Error fetching work type: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final workingTimeStr = workingHours != null
        ? "${workingHours!.inHours}h ${workingHours!.inMinutes.remainder(60)}m"
        : "Loading...";

    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.avatarId != null
                        ? NetworkImage("http://150.136.5.153:2280/cdn/${widget.avatarId}.png")
                        : null,
                    child: widget.avatarId == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text("Description: ${widget.description}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Address: ${widget.address}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text("Phone: ${widget.phonenumber}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            const Text("Start Date & Time:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Date: $startDateOnly"),
            Text("Time: $startTimeOnly"),
            const SizedBox(height: 10),
            const Text("End Date & Time:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Date: $endDateOnly"),
            Text("Time: $endTimeOnly"),
            const SizedBox(height: 10),
            Text("Working Duration: $workingTimeStr"),
            const SizedBox(height: 10),
            Text("Work Type: ${workType.isNotEmpty ? workType : 'Loading...'}"),
            const SizedBox(height: 10),
            Text("Price: \$${widget.workprice.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
