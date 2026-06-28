import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/viewmodels/theme_viewmodel.dart';
import 'core/theme/dharma_theme.dart';
import 'features/root/root_scaffold.dart';

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
      home: const RootScaffold(),
    );
  }
}
