import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/animated_scale_tap.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlassCard(
          borderRadius: 12,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            children: [
              SvgPicture.asset('assets/logo.svg', width: 42, height: 42),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Namaste 🙏', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Your Telugu AI Companion', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
            ],
          ),
        ),
      ],
    );
  }
}
