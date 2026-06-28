import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kGold = Color(0xFFFFC857);
const Color kDeepBlack = Color(0xFF050607);

final ColorScheme _darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: kGold,
  onPrimary: Colors.black,
  secondary: const Color(0xFFB08A00),
  onSecondary: Colors.white,
  error: Colors.red.shade400,
  onError: Colors.white,
  background: kDeepBlack,
  onBackground: Colors.white,
  surface: const Color(0x0FFFFFFF),
  onSurface: Colors.white,
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _darkScheme,
  scaffoldBackgroundColor: kDeepBlack,
  textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).apply(bodyColor: Colors.white),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.black.withOpacity(0.2),
    indicatorColor: kGold.withOpacity(0.16),
    labelTextStyle: MaterialStateProperty.all(const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    iconTheme: MaterialStateProperty.all(const IconThemeData(size: 20)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black.withOpacity(0.2),
    selectedItemColor: kGold,
    unselectedItemColor: Colors.white70,
  ),
);

final ThemeData lightTheme = ThemeData.light().copyWith(useMaterial3: true);
