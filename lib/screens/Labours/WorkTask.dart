import 'package:flutter/material.dart';

class Worktask extends StatefulWidget {
  const Worktask({super.key});

  @override
  State<Worktask> createState() => _WorktaskState();
}

class _WorktaskState extends State<Worktask> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Work Task Screen"),
    );
  }
}
