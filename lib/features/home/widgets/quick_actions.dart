import 'package:flutter/material.dart';
import '../../core/widgets/glass_card.dart';

class QuickAction {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  QuickAction({required this.label, required this.icon, this.color, this.onTap});
}

class QuickActionsGrid extends StatelessWidget {
  final List<QuickAction> actions;
  const QuickActionsGrid({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1),
      itemBuilder: (context, index) {
        final a = actions[index];
        return GlassCard(
          borderRadius: 14,
          padding: const EdgeInsets.all(12),
          onTap: a.onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withOpacity(0.95), Theme.of(context).colorScheme.secondary.withOpacity(0.75)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Icon(a.icon, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(a.label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)
            ],
          ),
        );
      },
    );
  }
}
