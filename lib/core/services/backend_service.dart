import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  final Uri base;
  final http.Client _client = http.Client();
  http.StreamedResponse? _currentStreamResponse;

  BackendService(this.base);

  Future<String> sendMessage(String token, String userMessage, {Map<String, dynamic>? options, List<dynamic>? conversationHistory, String? personalityId, String language = 'te'}) async {
    final url = base.replace(path: '${base.path}/v1/chat');
    final resp = await _client.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: jsonEncode({
      'userMessage': userMessage,
      'options': options ?? {},
      'conversationHistory': conversationHistory ?? [],
      'personalityId': personalityId,
      'language': language,
    }));
    if (resp.statusCode != 200) throw Exception('Backend error: ${resp.statusCode} ${resp.body}');
    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    return body['assistant'] as String;
  }

  /// Stream message via chunked SSE endpoint. Returns a Stream<String> of chunks.
  Stream<String> streamMessage(String token, String userMessage, {Map<String, dynamic>? options, List<dynamic>? conversationHistory, String? personalityId, String language = 'te'}) async* {
    final url = base.replace(path: '${base.path}/v1/chat/stream');
    final request = http.Request('POST', url);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.body = jsonEncode({
      'userMessage': userMessage,
      'options': options ?? {},
      'conversationHistory': conversationHistory ?? [],
      'personalityId': personalityId,
      'language': language,
    });

    final streamed = await _client.send(request);
    _currentStreamResponse = streamed;
    final stream = streamed.stream.transform(utf8.decoder);
    // SSE framing: lines like "data: chunk\n\n" and events
    final buffer = StringBuffer();
    await for (final part in stream) {
      buffer.write(part);
      // parse for data: ...\n\n
      final text = buffer.toString();
      int idx;
      while ((idx = text.indexOf('\n\n')) != -1) {
        final chunk = text.substring(0, idx);
        // remove processed
        buffer.clear();
        if (chunk.startsWith('data: ')) {
          final data = chunk.substring(6);
          if (data == '[DONE]') return;
          yield data;
        } else if (chunk.startsWith('event: error')) {
          // ignore for now
        }
      }
    }
  }

  Future<void> cancelStreaming() async {
    try {
      _currentStreamResponse?.stream.listen((_) {}).cancel();
    } catch (_) {}
    _currentStreamResponse = null;
  }
}
