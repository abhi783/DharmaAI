import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 48)),
            const SizedBox(height: 12),
            Text('Guest User', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text('Member since 2026', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
