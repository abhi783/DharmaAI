import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/viewmodels/theme_viewmodel.dart';
import 'core/theme/dharma_theme.dart';
import 'features/home/home_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/history/history_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';

class DharmaApp extends StatelessWidget {
  const DharmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      title: 'Dharma AI',
      debugShowCheckedModeBanner: false,
      themeMode: themeVM.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeAnimationDuration: const Duration(milliseconds: 400),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/chat': (_) => const ChatScreen(),
        '/history': (_) => const HistoryScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
