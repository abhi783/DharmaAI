import 'dart:async';
import 'ai_provider.dart';

/// OllamaProvider stub for future local LLM integrations.
class OllamaProvider implements AIProvider {
  @override
  String get providerId => 'ollama';

  @override
  String get providerName => 'Ollama (stub)';

  @override
  String get description => 'Ollama provider (stub) — implement Ollama/local LLM calls here.';

  @override
  String get assistantName => 'Dharma';

  @override
  bool get supportsStreaming => true;

  @override
  Future<String> sendMessage(String prompt, {Map<String, dynamic>? options}) async {
    await Future.delayed(const Duration(milliseconds: 380));
    return '[OllamaStub] Dharma: local LLM response (stub).';
  }

  @override
  Stream<String> streamMessage(String prompt, {Map<String, dynamic>? options}) async* {
    final resp = await sendMessage(prompt, options: options);
    // naive streaming: emit each word
    final parts = resp.split(' ');
    for (var i = 0; i < parts.length; i++) {
      await Future.delayed(const Duration(milliseconds: 60));
      yield parts[i] + (i == parts.length - 1 ? '' : ' ');
    }
  }

  @override
  Future<void> cancel() async {}
}
