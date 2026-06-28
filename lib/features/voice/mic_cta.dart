import 'package:flutter/material.dart';

/// A large Call-To-Action button used on the Home screen to start the
/// immersive "Talk to Dharma" experience.
class TalkToDharmaCTA extends StatelessWidget {
  final VoidCallback? onTap;
  const TalkToDharmaCTA({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.amber[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      elevation: 8,
      minimumSize: const Size(120, 48),
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
      tapTargetSize: MaterialTapTargetSize.padded,
    );

    return Center(
      child: Semantics(
        button: true,
        label: 'Talk to Dharma',
        hint: 'Tap to enter immersive voice mode',
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.mic, size: 22, color: Colors.black),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: Text('🎤 Talk to Dharma', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w700)),
          ),
          style: buttonStyle,
        ),
      ),
    );
  }
}
