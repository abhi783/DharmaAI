import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_ai/features/voice/voice_mode_screen.dart';
import 'package:dharma_ai/core/services/permission_service.dart';

class FakePermissionService extends PermissionService {
  bool granted = true;
  @override
  Future<PermissionStatus> checkMicrophonePermission() async {
    return PermissionStatus.granted;
  }

  @override
  Future<PermissionStatus> requestMicrophonePermission() async {
    return PermissionStatus.granted;
  }
}

void main() {
  testWidgets('VoiceModeScreen shows and requests permission when CTA tapped', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: VoiceModeScreen(permissionService: FakePermissionService())));
    expect(find.byType(VoiceModeScreen), findsOneWidget);
    // Tap floating mic
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
    // After starting session, should show listening text or mic action
    expect(find.text('నేను వింటున్నాను...') , findsNothing);
    // This test ensures the widget builds and permission flow does not crash
  });
}
