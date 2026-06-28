import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const gold = Color(0xFFFFC857);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: gold,
  brightness: Brightness.dark,
  background: const Color(0xFF0B0F12),
  surface: const Color(0xFF0F1316),
  onPrimary: Colors.black,
);

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: gold,
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: darkColorScheme.background,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: darkColorScheme.surface.withOpacity(0.3),
    selectedItemColor: gold,
    unselectedItemColor: Colors.white70,
  ),
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
);
