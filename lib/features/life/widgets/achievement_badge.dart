import 'package:flutter/material.dart';

class AchievementBadge extends StatelessWidget {
  final String title;
  final IconData icon;
  const AchievementBadge({super.key, required this.title, this.icon = Icons.emoji_events});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber.withOpacity(0.9), Colors.orangeAccent]), shape: BoxShape.circle),
        child: Center(child: Icon(icon, color: Colors.black)),
      ),
      const SizedBox(height: 6),
      Text(title, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center)
    ]);
  }
}
