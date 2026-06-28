import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History'), backgroundColor: Colors.transparent, elevation: 0),
      body: const Center(child: Text('No history yet — your conversations will appear here.')),
    );
  }
}
