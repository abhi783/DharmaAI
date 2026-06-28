import 'dart:async';
import 'ai_provider.dart';

/// A Mock provider used for development and offline testing. It purposely
/// contains no network calls and returns deterministic, safe content that
/// demonstrates behavior for the UI and the prompt-builder.
class MockProvider implements AIProvider {
  @override
  String get providerId => 'mock';

  @override
  String get providerName => 'Mock Provider';

  @override
  String get description => 'Local mock provider for development and testing.';

  @override
  String get assistantName => 'Dharma (Mock)';

  @override
  bool get supportsStreaming => true;

  StreamController<String>? _controller;

  @override
  Future<String> sendMessage(String prompt, {Map<String, dynamic>? options}) async {
    // A quick, deterministic reply that respects a "style" option when present.
    await Future.delayed(const Duration(milliseconds: 350));
    final style = options?['style'] ?? 'friendly';
    return '[Mock][$style] Dharma says: I heard you: "${prompt.replaceAll('\n', ' ')}"';
  }

  @override
  Stream<String> streamMessage(String prompt, {Map<String, dynamic>? options}) async* {
    _controller?.close();
    _controller = StreamController<String>();

    // Simulate tokenized streaming
    final words = ('Dharma (mock) responding to: ' + prompt).split(' ');
    for (var i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      yield (i == words.length - 1) ? words[i] + '\n' : words[i] + ' ';
    }
  }

  @override
  Future<void> cancel() async {
    await _controller?.close();
    _controller = null;
  }
}
