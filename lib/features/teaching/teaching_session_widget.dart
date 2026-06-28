import 'package:flutter/material.dart';

class TeachingSectionWidget extends StatelessWidget {
  final String title;
  final String body;
  final bool active;
  const TeachingSectionWidget({super.key, required this.title, required this.body, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$title. $body',
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 420),
        opacity: active ? 1.0 : 0.0,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 420),
          offset: active ? Offset.zero : const Offset(0, 0.08),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.amberAccent, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(body, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
            ]),
          ),
        ),
      ),
    );
  }
}

class TeachingSessionWidget extends StatelessWidget {
  final dynamic teaching; // TeachingResponse
  final int activeIndex;
  const TeachingSessionWidget({super.key, required this.teaching, required this.activeIndex});

  List<Map<String, String>> _sectionsFromTeaching(dynamic t) {
    final List<Map<String, String>> out = [];
    out.add({'title': 'Simple Answer', 'text': t.simpleAnswer});
    out.add({'title': 'Explanation', 'text': t.explanation});
    out.add({'title': 'Example', 'text': t.example});
    if (t.verifiedTeaching != null) {
      out.add({'title': 'Verified Teaching', 'text': t.verifiedTeaching});
      out.add({'title': 'Traditional Interpretation', 'text': t.traditionalInterpretation ?? ''});
      out.add({'title': 'Modern Application', 'text': t.modernApplication ?? ''});
    }
    out.add({'title': 'Summary', 'text': t.summary});
    out.add({'title': 'Reflection', 'text': t.reflectionQuestion});
    if (t.relatedSuggestion != null) out.add({'title': 'Suggested Next Topic', 'text': t.relatedSuggestion});
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final sections = _sectionsFromTeaching(teaching);
    return Column(children: [
      for (int i = 0; i < sections.length; i++) TeachingSectionWidget(title: sections[i]['title'] ?? '', body: sections[i]['text'] ?? '', active: activeIndex == i),
    ]);
  }
}
