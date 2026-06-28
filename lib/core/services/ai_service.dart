import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey;
  AIService({required this.apiKey});

  Future<String> sendMessage(String message) async {
    // Placeholder: integrate your preferred AI endpoint here (OpenAI, Azure, local LLM)
    // This currently simulates a network call.
    await Future.delayed(const Duration(milliseconds: 700));
    return 'Simulated AI response for: $message';
  }
}
