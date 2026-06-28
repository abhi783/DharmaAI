import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// VoiceService provides a simple, testable wrapper around STT and TTS.
/// - Telugu-first: attempts to prefer Telugu voices when available.
/// - Exposes streams for partial transcripts, final transcript events and amplitude (sound level).
class VoiceService {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _stt = stt.SpeechToText();

  final StreamController<String> _partialController = StreamController.broadcast();
  final StreamController<String> _finalController = StreamController.broadcast();
  final StreamController<bool> _listeningController = StreamController.broadcast();
  final StreamController<double> _amplitudeController = StreamController.broadcast();

  bool _listening = false;
  String _currentLocaleId = 'te-IN';

  VoiceService();

  Stream<String> get partialTranscript => _partialController.stream;
  Stream<String> get finalTranscript => _finalController.stream;
  Stream<bool> get listeningState => _listeningController.stream;
  Stream<double> get amplitude => _amplitudeController.stream;

  Future<void> init() async {
    // initialize TTS
    await _tts.setSharedInstance(true);
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);

    // initialize STT (permissions must be requested by the caller)
    try {
      await _stt.initialize(onError: (e) => {}, onStatus: (s) => {});
    } catch (e) {
      // ignore for now; platform may not have permission yet
    }
  }

  Future<List<dynamic>> getVoices() async {
    try {
      final voices = await _tts.getVoices;
      return voices ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<void> setVoice(String voice) async {
    try {
      await _tts.setVoice({'name': voice});
    } catch (_) {}
  }

  Future<void> setRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
  }

  Future<void> startListening({String localeId = 'te-IN', bool partialResults = true}) async {
    if (_listening) return;
    _currentLocaleId = localeId;

    final available = await _stt.initialize();
    if (!available) {
      _listeningController.add(false);
      return;
    }

    _listening = true;
    _listeningController.add(true);

    _stt.listen(onResult: (result) {
      final text = result.recognizedWords;
      if (result.finalResult) {
        _finalController.add(text);
      } else {
        _partialController.add(text);
      }
    }, onSoundLevelChange: (level) {
      // speech_to_text reports a dB value; normalize to 0..1
      final normalized = (level + 50) / 60.0; // approximate
      _amplitudeController.add(normalized.clamp(0.0, 1.0));
    }, localeId: _currentLocaleId, partialResults: partialResults);
  }

  Future<void> stopListening() async {
    if (!_listening) return;
    await _stt.stop();
    _listening = false;
    _listeningController.add(false);
  }

  void dispose() {
    _partialController.close();
    _finalController.close();
    _listeningController.close();
    _amplitudeController.close();
  }
}
