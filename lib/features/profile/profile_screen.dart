import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleAvatar(radius: 46, child: Icon(Icons.person, size: 46)),
          const SizedBox(height: 12),
          Text('Guest User', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text('Member since 2026', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
        ]),
      ),
    );
  }
}
