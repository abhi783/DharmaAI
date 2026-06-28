import 'package:flutter/material.dart';

/// A large Call-To-Action button used on the Home screen to start the
/// immersive "Talk to Dharma" experience.
class TalkToDharmaCTA extends StatelessWidget {
  final VoidCallback? onTap;
  const TalkToDharmaCTA({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.mic, size: 22, color: Colors.black),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
          child: Text('🎤 Talk to Dharma', style: TextStyle(fontSize: 18, color: Colors.black)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          elevation: 8,
        ),
      ),
    );
  }
}
