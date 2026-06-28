import 'dart:async';
import 'ai_provider.dart';

/// OpenAIProvider is a stub implementation that conforms to the provider
/// interface but does not make any network calls. This keeps the app free of
/// API keys and still fulfills compile-time and runtime expectations. When you
/// later plug a real implementation, keep the interface intact.
class OpenAIProvider implements AIProvider {
  @override
  String get providerId => 'openai';

  @override
  String get providerName => 'OpenAI (stub)';

  @override
  String get description => 'OpenAI provider (stub) — integrate real OpenAI calls here.';

  @override
  String get assistantName => 'Dharma';

  @override
  bool get supportsStreaming => false;

  @override
  Future<String> sendMessage(String prompt, {Map<String, dynamic>? options}) async {
    // Maintain deterministic behavior for testing until real integration is added.
    await Future.delayed(const Duration(milliseconds: 400));
    return '[OpenAIStub] Dharma: I received your message.';
  }

  @override
  Stream<String> streamMessage(String prompt, {Map<String, dynamic>? options}) async* {
    yield await sendMessage(prompt, options: options);
  }

  @override
  Future<void> cancel() async {}
}
