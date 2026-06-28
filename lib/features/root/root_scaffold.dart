import 'package:flutter/material.dart';
import '../../features/home/home_screen.dart';
import '../../features/discover/discover_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/profile/profile_screen.dart';

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _selected = 0;

  final _pages = const [HomeScreen(), DiscoverScreen(), ChatScreen(), HistoryScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selected, children: _pages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: NavigationBar(
          selectedIndex: _selected,
          onDestinationSelected: (i) => setState(() => _selected = i),
          height: 66,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
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
