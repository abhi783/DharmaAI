import 'package:flutter/material.dart';
import 'home_header.dart';
import 'home_cards.dart';
import '../../core/theme/dharma_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      HomeCardData(label: 'AI Chat', assetName: 'assets/logo.svg', onTap: () => Navigator.pushNamed(context, '/chat')),
      HomeCardData(label: 'Voice Chat', assetName: 'assets/logo.svg', onTap: () => Navigator.pushNamed(context, '/chat')),
      HomeCardData(label: 'Bhagavad Gita', assetName: 'assets/logo.svg', onTap: () {}),
      HomeCardData(label: 'Ramayanam', assetName: 'assets/logo.svg', onTap: () {}),
      HomeCardData(label: 'Mahabharatam', assetName: 'assets/logo.svg', onTap: () {}),
      HomeCardData(label: 'Daily Wisdom', assetName: 'assets/logo.svg', onTap: () {}),
      HomeCardData(label: 'Settings', assetName: 'assets/logo.svg', onTap: () => Navigator.pushNamed(context, '/settings')),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const SizedBox(height: 18),
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      const Icon(Icons.smart_toy_outlined, size: 28, color: gold),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Talk to Dharma AI — get answers in Telugu, insights from scriptures, and daily wisdom.', style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/chat'),
                        style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: gold, foregroundColor: Colors.black),
                        child: const Text('Start'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                HomeCardsGrid(items: cards),
                const SizedBox(height: 72),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (idx) {
          switch (idx) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/chat');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/history');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
