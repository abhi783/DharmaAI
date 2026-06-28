class TeachingResponse {
  final String simpleAnswer;
  final String explanation;
  final String example;
  final String? verifiedTeaching;
  final String? traditionalInterpretation;
  final String? modernApplication;
  final String summary;
  final String reflectionQuestion;
  final String? relatedSuggestion;

  TeachingResponse({
    required this.simpleAnswer,
    required this.explanation,
    required this.example,
    this.verifiedTeaching,
    this.traditionalInterpretation,
    this.modernApplication,
    required this.summary,
    required this.reflectionQuestion,
    this.relatedSuggestion,
  });

  Map<String, dynamic> toJson() => {
        'simpleAnswer': simpleAnswer,
        'explanation': explanation,
        'example': example,
        'verifiedTeaching': verifiedTeaching,
        'traditionalInterpretation': traditionalInterpretation,
        'modernApplication': modernApplication,
        'summary': summary,
        'reflectionQuestion': reflectionQuestion,
        'relatedSuggestion': relatedSuggestion,
      };
}

/// TeachingEngine is a modular, provider-independent formatter that
/// structures educational responses in a mentor-like format. It accepts
/// either explicit parts (preferred) or a raw provider text and applies
/// lightweight heuristics to build the teaching structure.
class TeachingEngine {
  TeachingEngine();

  /// Create a TeachingResponse from explicit parts. This is the recommended
  /// usage when you already have the main content (for example, produced
  /// by a large language model or another generator). The engine only
  /// structures and validates the parts.
  TeachingResponse createFromParts({
    required String simpleAnswer,
    required String explanation,
    required String example,
    String? verifiedTeaching,
    String? traditionalInterpretation,
    String? modernApplication,
    required String summary,
    required String reflectionQuestion,
    String? relatedSuggestion,
  }) {
    return TeachingResponse(
      simpleAnswer: _ensureShort(simpleAnswer),
      explanation: _ensureReadableTelugu(explanation),
      example: _ensureRealLifeExample(example),
      verifiedTeaching: verifiedTeaching,
      traditionalInterpretation: traditionalInterpretation,
      modernApplication: modernApplication,
      summary: _ensureShortParagraph(summary),
      reflectionQuestion: _ensureQuestion(reflectionQuestion),
      relatedSuggestion: relatedSuggestion,
    );
  }

  /// Attempt to build a TeachingResponse from raw provider text. This will
  /// use simple heuristics: the first sentence becomes the simple answer,
  /// the next few sentences become explanation, any paragraph that includes
  /// the word "example" or similar becomes the example, and the tail is
  /// used as summary/reflection. This is a fallback; prefer createFromParts.
  TeachingResponse createFromProviderText({
    required String providerText,
    bool isScripture = false,
    String? scriptureSourceName,
    String? topic,
    String? relatedSuggestion,
  }) {
    final sentences = _splitIntoSentences(providerText);
    final simple = sentences.isNotEmpty ? sentences.first : 'సరదాగా శిక్షణ మొదలు.';

    // Explanation: next 2-3 sentences or next paragraph
    final explanation = sentences.length > 1
        ? sentences.sublist(1, sentences.length > 4 ? 4 : sentences.length).join(' ')
        : providerText;

    // Example heuristic: find a paragraph containing 'ఉదాహరణ' or 'example' or 'for example'
    final example = _findExampleParagraph(providerText) ?? 'ఇది జీవితం నుండి ఒక సరళమైన ఉదాహరణ: ...';

    // Summary: last 1-2 sentences
    final summary = sentences.length >= 2 ? sentences.sublist((sentences.length - 2).clamp(1, sentences.length - 1)).join(' ') : explanation;

    // Reflection question heuristic
    final reflection = 'ఈ గురువుపై మీరు ఏమైనా ఆచరణలో పెట్టగలరా?';

    String? verified, traditional, modern;
    if (isScripture && scriptureSourceName != null) {
      verified = 'Verified teaching from $scriptureSourceName.';
      traditional = 'Traditional interpretation (concise).';
      modern = 'Modern practical application (concise).';
    }

    return TeachingResponse(
      simpleAnswer: _ensureShort(simple),
      explanation: _ensureReadableTelugu(explanation),
      example: _ensureRealLifeExample(example),
      verifiedTeaching: verified,
      traditionalInterpretation: traditional,
      modernApplication: modern,
      summary: _ensureShortParagraph(summary),
      reflectionQuestion: _ensureQuestion(reflection),
      relatedSuggestion: relatedSuggestion,
    );
  }

  String _ensureShort(String s) {
    final t = s.trim();
    if (t.length <= 220) return t;
    return _shortenToSentences(t, 2);
  }

  String _ensureReadableTelugu(String s) {
    // Placeholder for a real language quality pass. Keep simple for now.
    return s.trim();
  }

  String _ensureRealLifeExample(String s) {
    final t = s.trim();
    if (t.isEmpty) return 'ఉదాహరణ: ఒక సాధారణ రోజులో ఇలా చేయండి...';
    return t;
  }

  String _ensureShortParagraph(String s) {
    final t = s.trim();
    if (t.length <= 400) return t;
    return _shortenToSentences(t, 3);
  }

  String _ensureQuestion(String s) {
    final t = s.trim();
    if (t.endsWith('?')) return t;
    return '$t?';
  }

  List<String> _splitIntoSentences(String text) {
    // Very small heuristic sentence splitter for Telugu/English mixing.
    final parts = text.split(RegExp(r'(?<=[\.\?!।])\s+'));
    return parts.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  String? _findExampleParagraph(String text) {
    final lowered = text.toLowerCase();
    final idx = lowered.indexOf('ఉదాహరణ');
    if (idx != -1) {
      // return the paragraph containing the keyword
      final paras = text.split('\n\n');
      for (final p in paras) {
        if (p.toLowerCase().contains('ఉదాహరణ')) return p.trim();
      }
    }
    if (lowered.contains('for example') || lowered.contains('example')) {
      final paras = text.split('\n\n');
      for (final p in paras) {
        if (p.toLowerCase().contains('example') || p.toLowerCase().contains('for example')) return p.trim();
      }
    }
    return null;
  }

  String _shortenToSentences(String text, int maxSentences) {
    final s = _splitIntoSentences(text);
    final take = s.take(maxSentences).join(' ');
    return take;
  }
}
