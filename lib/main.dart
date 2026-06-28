import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/viewmodels/theme_viewmodel.dart';
import 'core/viewmodels/ai_settings_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => AiSettingsViewModel()),
      ],
      child: const DharmaApp(),
    ),
  );
}
