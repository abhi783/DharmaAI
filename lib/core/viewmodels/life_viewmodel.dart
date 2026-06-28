import 'package:flutter/material.dart';
import '../services/daily_companion_service.dart';

class LearningItem {
  final String id;
  final String title;
  final double progress; // 0.0 - 1.0
  LearningItem({required this.id, required this.title, required this.progress});
}

class LearningJourney {
  final List<LearningItem> items;
  LearningJourney({required this.items});
}

class LifeViewModel extends ChangeNotifier {
  late DailyCompanion dailyCompanion;
  late LearningJourney learningJourney;
  List<String> suggestedConversations = [];
  List<String> recentLearned = [];
  String? recentChatTitle;

  LifeViewModel() {
    _init();
  }

  void _init() {
    dailyCompanion = DailyCompanionService.generateForDate(DateTime.now());
    learningJourney = LearningJourney(items: [
      LearningItem(id: 'gita', title: 'Bhagavad Gita', progress: 0.32),
      LearningItem(id: 'rama', title: 'Ramayanam', progress: 0.12),
      LearningItem(id: 'career', title: 'Career Learning', progress: 0.46),
    ]);
    suggestedConversations = ['Ask about Dharma today', 'Plan my day', 'Teach me a Telugu word'];
    recentLearned = ['Verse 2.47 summary', 'Ramayanam chapter 1 highlight'];
    recentChatTitle = 'Dharma — morning reflection';
  }

  Future<void> refreshDailyCompanion() async {
    dailyCompanion = DailyCompanionService.generateForDate(DateTime.now());
    notifyListeners();
  }

  String get greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get subGreeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Ready for a mindful day?';
    if (h < 18) return 'Keep going, you are doing well.';
    return 'Time to reflect and unwind.';
  }
}
