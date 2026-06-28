import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// TelemetryService collects anonymous UX events. It never stores or sends
/// conversation content or personal data. Events are only sent when the
/// user opts-in to telemetry. For now the service stores events locally
/// and prints them; integration with an analytics endpoint can be added
/// later and will respect opt-in.
class TelemetryService {
  static final TelemetryService _instance = TelemetryService._internal();
  factory TelemetryService() => _instance;
  TelemetryService._internal();

  final StreamController<Map<String, dynamic>> _events = StreamController.broadcast();
  bool _optIn = false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _optIn = prefs.getBool('telemetry_opt_in') ?? false;
  }

  Future<void> setOptIn(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('telemetry_opt_in', v);
    _optIn = v;
  }

  void logEvent(String name, Map<String, dynamic> payload) {
    final event = {'name': name, 'payload': payload, 'ts': DateTime.now().toIso8601String()};
    // Always record locally in the stream for listeners (debugging). Do NOT send content.
    _events.add(event);
    if (_optIn) {
      // Placeholder for future network send. For now, print (no content will be transmitted).
      // In production this would POST to a telemetry endpoint with only anonymous metadata.
      print('[telemetry] $event');
    }
  }

  Stream<Map<String, dynamic>> get events => _events.stream;
}
