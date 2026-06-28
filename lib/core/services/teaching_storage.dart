import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../core/teaching/teaching_engine.dart';

class TeachingSessionStorage {
  static const _key = 'saved_learning_sessions_v1';

  TeachingSessionStorage._privateConstructor();
  static final TeachingSessionStorage instance = TeachingSessionStorage._privateConstructor();

  Future<List<Map<String, dynamic>>> _getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSession(TeachingResponse teaching, {String? title}) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await _getAll();
    final entry = {
      'createdAt': DateTime.now().toIso8601String(),
      'title': title ?? teaching.simpleAnswer.substring(0, teaching.simpleAnswer.length.clamp(10, 80)),
      'teaching': teaching.toJson(),
    };
    all.insert(0, entry);
    await prefs.setString(_key, jsonEncode(all));
  }

  Future<void> deleteSessionAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await _getAll();
    if (index < 0 || index >= all.length) return;
    all.removeAt(index);
    await prefs.setString(_key, jsonEncode(all));
  }

  Future<List<Map<String, dynamic>>> listSessions() async {
    return await _getAll();
  }
}
