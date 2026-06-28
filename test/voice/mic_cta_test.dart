import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dharma_ai/features/voice/mic_cta.dart';

void main() {
  testWidgets('TalkToDharmaCTA renders and responds to tap', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TalkToDharmaCTA(onTap: () { tapped = true; }))));
    expect(find.byType(TalkToDharmaCTA), findsOneWidget);
    await tester.tap(find.byType(TalkToDharmaCTA));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });
}
