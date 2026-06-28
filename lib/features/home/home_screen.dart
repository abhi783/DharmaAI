import 'package:flutter/material.dart';
import '../../core/theme/header_arc_painter.dart';
import '../../core/widgets/glass_card.dart';
import 'widgets/animated_greeting.dart';
import 'widgets/quick_actions.dart';
import 'widgets/quote_carousel.dart';
import '../../core/theme/dharma_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quickActions = [
      QuickAction(label: 'Ask Anything', icon: Icons.chat_bubble_outline, onTap: () => Navigator.pushNamed(context, '/chat')),
      QuickAction(label: 'Voice Mode', icon: Icons.mic_none, onTap: () => Navigator.pushNamed(context, '/chat')),
      QuickAction(label: 'Learn Today', icon: Icons.lightbulb_outline, onTap: () {}),
      QuickAction(label: 'Bhagavad Gita', icon: Icons.menu_book_outlined, onTap: () {}),
      QuickAction(label: 'Ramayanam', icon: Icons.auto_stories, onTap: () {}),
      QuickAction(label: 'Mahabharatam', icon: Icons.shield_outlined, onTap: () {}),
      QuickAction(label: 'Motivation', icon: Icons.favorite_border, onTap: () {}),
      QuickAction(label: 'Career', icon: Icons.work_outline, onTap: () {}),
      QuickAction(label: 'Money', icon: Icons.paid_outlined, onTap: () {}),
      QuickAction(label: 'Relationships', icon: Icons.favorite, onTap: () {}),
      QuickAction(label: 'Health', icon: Icons.fitness_center, onTap: () {}),
      QuickAction(label: 'Education', icon: Icons.school_outlined, onTap: () {}),
    ];

    final quotes = [
      'న్యాయం మరియు ధర్మం మార్గం చూపును. — భవిష్యత్తుకై జీవించు',
      'ప్రతిది మారుతుంది; మీరు మహత్తరంగా ఉండండి. — రోజువారీ శైలి',
      'జ్ఞానం వెలుగు; ధ్యానం దారి. — తపస్వి'
    ];

    return Scaffold(
      backgroundColor: kDeepBlack,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: HeaderArcPainter(gold: kGold),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Hero(
                          tag: 'dharma-logo',
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [kGold, kGold.withOpacity(0.9)]),
                            ),
                            child: Center(child: Text('D', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kDeepBlack, fontWeight: FontWeight.w800))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [AnimatedGreeting()])),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/chat'),
                      child: Hero(
                        tag: 'search-hero',
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          borderRadius: 14,
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.white70),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text('ఏం తెలుసుకోవాలనుకుంటున్నారు?', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                                child: Row(children: const [Icon(Icons.mic, size: 16), SizedBox(width: 6), Text('Voice', style: TextStyle(fontSize: 12))]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    GlassCard(
                      borderRadius: 16,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          QuickActionsGrid(actions: quickActions),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text("Today's Wisdom", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      TextButton(onPressed: () {}, child: const Text('See all'))
                    ]),
                    const SizedBox(height: 8),
                    GlassCard(
                      borderRadius: 16,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('"Be the light you seek"', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          QuoteCarousel(quotes: quotes),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('Recent Chats', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(3, (i) => _RecentChatTile(index: i)),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _RecentChatTile extends StatelessWidget {
  final int index;
  const _RecentChatTile({required this.index});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'recent-$index',
      child: GlassCard(
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        onTap: () => Navigator.pushNamed(context, '/chat'),
        child: Row(
          children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.chat_bubble_outline)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Chat with Dharma', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text('How can I improve my daily routine?', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70))])),
            const Icon(Icons.chevron_right, color: Colors.white54)
          ],
        ),
      ),
    );
  }
}
