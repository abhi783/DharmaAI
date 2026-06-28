import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Dark Mode')),
          ListTile(title: const Text('Voice Settings'), leading: const Icon(Icons.mic)),
          ListTile(title: const Text('AI Model'), leading: const Icon(Icons.psychology)),
          ListTile(title: const Text('Privacy'), leading: const Icon(Icons.lock)),
        ],
      ),
    );
  }
}
