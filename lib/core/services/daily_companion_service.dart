import 'dart:math';

class DailyCompanion {
  final String morningMotivation;
  final String wisdom;
  final String gitaConcept;
  final String productivityTip;
  final String healthTip;
  final String financialTip;
  final String teluguWord;
  final String challenge;
  final String goal;
  final String quote;

  DailyCompanion({
    required this.morningMotivation,
    required this.wisdom,
    required this.gitaConcept,
    required this.productivityTip,
    required this.healthTip,
    required this.financialTip,
    required this.teluguWord,
    required this.challenge,
    required this.goal,
    required this.quote,
  });
}

class DailyCompanionService {
  static final _words = ['సుఖం', 'ధైర్యం', 'ఆశ', 'శాంతి', 'జ్ఞానం'];
  static final _quotes = [
    'జ్ఞానం వెలుగు; దాన్ని పంచుకోండి.',
    'సదా ధర్మమే మనకు దారి చూపును.',
    'ప్రయత్నమే విజయానికి మూలం.'
  ];

  static DailyCompanion generateForDate(DateTime date) {
    final r = Random(date.millisecondsSinceEpoch);
    return DailyCompanion(
      morningMotivation: 'Today is a new chance — take one small step towards your goal.',
      wisdom: _quotes[r.nextInt(_quotes.length)],
      gitaConcept: 'Karma Yoga — Focus on your duty without attachment to results.',
      productivityTip: 'Use the Pomodoro technique: 25 minutes focused work + 5 minutes rest.',
      healthTip: 'Start the day with a glass of water and 10 minutes of stretching.',
      financialTip: 'Review one small expense today; small savings add up.',
      teluguWord: _words[r.nextInt(_words.length)],
      challenge: 'Replace 30 minutes of passive scrolling with reading or learning.',
      goal: 'Complete one focused learning session of 25 minutes.',
      quote: _quotes[r.nextInt(_quotes.length)],
    );
  }
}
