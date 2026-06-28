import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// VoiceService provides a simple, testable wrapper around STT and TTS.
/// - Telugu-first: attempts to prefer Telugu voices when available.
/// - Exposes streams for partial transcripts and final transcript events.
class VoiceService {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _stt = stt.SpeechToText();

  final StreamController<String> _partialController = StreamController.broadcast();
  final StreamController<String> _finalController = StreamController.broadcast();
  final StreamController<bool> _listeningController = StreamController.broadcast();

  bool _listening = false;
  String _currentLocaleId = 'te-IN';

  VoiceService();

  Stream<String> get partialTranscript => _partialController.stream;
  Stream<String> get finalTranscript => _finalController.stream;
  Stream<bool> get listeningState => _listeningController.stream;

  Future<void> init() async {
    // initialize TTS
    await _tts.setSharedInstance(true);
    // set default params
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);

    // initialize STT
    try {
      await _stt.initialize();
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
  }
}
