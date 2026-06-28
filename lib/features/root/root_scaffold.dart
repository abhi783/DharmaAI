import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/life/life_screen.dart';
import '../../features/discover/discover_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../core/viewmodels/life_viewmodel.dart';

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _selected = 0;

  Widget _pageForIndex(int i) {
    switch (i) {
      case 0:
        return const LifeScreen();
      case 1:
        return const DiscoverScreen();
      case 2:
        return const ChatScreen();
      case 3:
        return const HistoryScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const LifeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selected, children: List.generate(5, (i) => _pageForIndex(i))),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: NavigationBar(
          selectedIndex: _selected,
          onDestinationSelected: (i) => setState(() => _selected = i),
          height: 66,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Life'),
            NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Discover'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
            NavigationDestination(icon: Icon(Icons.history), label: 'History'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
