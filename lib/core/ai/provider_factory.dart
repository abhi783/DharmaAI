import 'package:shared_preferences/shared_preferences.dart';
import 'ai_provider.dart';
import 'mock_provider.dart';
import 'openai_provider.dart';
import 'gemini_provider.dart';
import 'ollama_provider.dart';

/// ProviderFactory is responsible for creating provider instances and
/// remembering the user selection. UI code should not instantiate providers
/// directly — instead it should ask the factory for the active provider.
class ProviderFactory {
  static const _kProviderKey = 'selected_ai_provider';

  static final Map<String, AIProvider> _registry = {
    'mock': MockProvider(),
    'openai': OpenAIProvider(),
    'gemini': GeminiProvider(),
    'ollama': OllamaProvider(),
  };

  /// Returns available provider ids in preferred order.
  static List<AIProvider> availableProviders() => _registry.values.toList();

  /// Create or fetch the provider identified by [id]. Returns the mock
  /// provider if the id is unknown.
  static AIProvider providerForId(String id) => _registry[id] ?? _registry['mock']!;

  /// Persist the selected provider id to shared preferences for future app
  /// restarts.
  static Future<void> setSelectedProviderId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kProviderKey, id);
  }

  /// Get the previously persisted provider id. Returns 'mock' if not set.
  static Future<String> getSelectedProviderId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kProviderKey) ?? 'mock';
  }
}
