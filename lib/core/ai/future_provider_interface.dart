import 'dart:async';

/// FutureProviderInterface defines the asynchronous contract any AI provider must
/// expose to the rest of the application. Implementations can provide both
/// request/response and streaming behaviors.
abstract class FutureProviderInterface {
  /// Human readable provider id (eg: 'openai', 'gemini')
  String get providerId;

  /// Provider display name
  String get providerName;

  /// Whether this provider supports streaming responses
  bool get supportsStreaming;

  /// Send a prompt and receive a final textual response.
  Future<String> sendMessage(String prompt, {Map<String, dynamic>? options});

  /// Send a prompt and receive a stream of chunks (for streaming-capable providers).
  /// If the provider does not support streaming, implementers may yield the full
  /// response once.
  Stream<String> streamMessage(String prompt, {Map<String, dynamic>? options});

  /// Optional: cancel an in-flight streaming request
  Future<void> cancel();
}
