import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/animated_scale_tap.dart';

class HomeCardData {
  final String label;
  final String assetName;
  final VoidCallback? onTap;
  HomeCardData({required this.label, required this.assetName, this.onTap});
}

class HomeCardsGrid extends StatelessWidget {
  final List<HomeCardData> items;
  const HomeCardsGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 14, mainAxisSpacing: 14),
      itemBuilder: (context, index) {
        final it = items[index];
        return AnimatedScaleTap(
          onTap: it.onTap,
          child: GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(it.assetName, width: 36, height: 36, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 12),
                Text(it.label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                Align(alignment: Alignment.bottomRight, child: Icon(Icons.chevron_right, color: Colors.white70))
              ],
            ),
          ),
        );
      },
    );
  }
}
