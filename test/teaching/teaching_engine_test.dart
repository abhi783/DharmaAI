import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_ai/core/teaching/teaching_engine.dart';

void main() {
  group('TeachingEngine', () {
    test('createFromParts returns structured TeachingResponse', () {
      final engine = TeachingEngine();
      final resp = engine.createFromParts(
        simpleAnswer: 'సూర్యుడు ఉదయం ఉదయిస్తాడు.',
        explanation: 'సూర్యుడు ప్రతి రోజూ ఉదయిస్తాడు అంటే ఇది ప్రకృతి చక్రం.',
        example: 'ఉదాహరణ: ప్రతి ఉదయం సూర్యోదయం చూస్తే మీ రోజూ మంచిగా ఉంటుంది.',
        summary: 'సూర్యోదయం మనకి కొత్త ఆరంభం సూచిస్తుంది.',
        reflectionQuestion: 'ఈ రోజు మీరు ఏదైనా కొత్త ప్రారంభించగలరా',
        relatedSuggestion: 'మరింత తెలుసుకోవడానికి: ప్రకృతి చక్రం గురించి చదవండి',
      );

      expect(resp.simpleAnswer.startsWith('సూర्यుడు'), isTrue);
      expect(resp.explanation.contains('ప్రకృతి'), isTrue);
      expect(resp.example.contains('ఉదాహరణ'), isTrue);
      expect(resp.summary.isNotEmpty, isTrue);
      expect(resp.reflectionQuestion.endsWith('?'), isTrue);
    });

    test('createFromProviderText handles scripture flag', () {
      final engine = TeachingEngine();
      final provider = 'శ్లോകం 2.47: నీ కర్తవ్యంపై ఫలానికి ఆకర్షణ లేకుండా పని చేయవలెను. ఉదాహరణ: అజ్ఞాతో ఒక వ్యక్తి పని చేయడం.';
      final resp = engine.createFromProviderText(providerText: provider, isScripture: true, scriptureSourceName: 'Bhagavad Gita');
      expect(resp.verifiedTeaching != null, isTrue);
      expect(resp.traditionalInterpretation != null, isTrue);
      expect(resp.modernApplication != null, isTrue);
    });
  });
}
