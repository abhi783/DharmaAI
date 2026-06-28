import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// BackendService provides a simple SSE consumer for the Dharma Brain
/// teaching stream. It connects to the configured teaching endpoint and
/// yields parsed events as Maps with keys: 'event' and 'data'.
class BackendService {
  BackendService._privateConstructor();
  static final BackendService instance = BackendService._privateConstructor();

  // Change this to your server address when testing on device.
  // For Android emulator, `10.0.2.2` maps to localhost on the host machine.
  String baseUrl = const String.fromEnvironment('DHARMA_BRAIN_URL', defaultValue: 'http://10.0.2.2:8090');

  Stream<Map<String, dynamic>> streamTeaching({required String query, String? style}) async* {
    final uri = Uri.parse('$baseUrl/v1/teaching-stream');
    final body = jsonEncode({ 'query': query, if (style != null) 'style': style });

    final request = http.Request('POST', uri);
    request.headers['Content-Type'] = 'application/json';
    request.body = body;

    final client = http.Client();
    final streamedResponse = await client.send(request);

    // Read the byte stream line by line and parse SSE events.
    final lines = streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    String? currentEvent;
    StringBuffer dataBuf = StringBuffer();

    await for (final line in lines) {
      if (line.startsWith('event:')) {
        currentEvent = line.replaceFirst('event:', '').trim();
      } else if (line.startsWith('data:')) {
        dataBuf.writeln(line.replaceFirst('data:', '').trim());
      } else if (line.trim().isEmpty) {
        // End of event
        if (dataBuf.isNotEmpty) {
          final raw = dataBuf.toString().trim();
          try {
            final jsonObj = jsonDecode(raw);
            yield { 'event': currentEvent, 'data': jsonObj };
          } catch (e) {
            // ignore parse errors but continue
          }
        }
        // reset
        currentEvent = null;
        dataBuf = StringBuffer();
      } else {
        // unknown line; append to data
        dataBuf.writeln(line);
      }
    }

    client.close();
  }
}
