import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ai/provider_factory.dart';

/// ViewModel that stores AI settings (selected provider, personality, language)
/// and exposes convenient setters for the UI. It persists choices using
/// SharedPreferences so the selection survives restarts.
class AiSettingsViewModel extends ChangeNotifier {
  static const _kPersonalityKey = 'selected_personality';
  static const _kLanguageKey = 'selected_language';

  String _providerId = 'mock';
  String get providerId => _providerId;

  String _personalityId = 'dharma_default';
  String get personalityId => _personalityId;

  String _language = 'te';
  String get language => _language;

  AiSettingsViewModel() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _providerId = prefs.getString('selected_ai_provider') ?? 'mock';
    _personalityId = prefs.getString(_kPersonalityKey) ?? 'dharma_default';
    _language = prefs.getString(_kLanguageKey) ?? 'te';
    notifyListeners();
  }

  Future<void> setProvider(String id) async {
    _providerId = id;
    await ProviderFactory.setSelectedProviderId(id);
    notifyListeners();
  }

  Future<void> setPersonality(String id) async {
    _personalityId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPersonalityKey, id);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguageKey, lang);
    notifyListeners();
  }
}
