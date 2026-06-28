import 'dart:async';
import 'ai_provider.dart';

/// GeminiProvider stub. Keeps parity with other providers to make swapping
/// providers trivial later on.
class GeminiProvider implements AIProvider {
  @override
  String get providerId => 'gemini';

  @override
  String get providerName => 'Gemini (stub)';

  @override
  String get description => 'Gemini provider (stub) — implement actual Gemini calls here.';

  @override
  String get assistantName => 'Dharma';

  @override
  bool get supportsStreaming => false;

  @override
  Future<String> sendMessage(String prompt, {Map<String, dynamic>? options}) async {
    await Future.delayed(const Duration(milliseconds: 380));
    return '[GeminiStub] Dharma: Response available.';
  }

  @override
  Stream<String> streamMessage(String prompt, {Map<String, dynamic>? options}) async* {
    yield await sendMessage(prompt, options: options);
  }

  @override
  Future<void> cancel() async {}
}
