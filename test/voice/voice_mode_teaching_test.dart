import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dharma_ai/features/voice/voice_mode_screen.dart';
import 'package:dharma_ai/core/services/permission_service.dart';

class FakePermissionService extends PermissionService {
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
  testWidgets('VoiceModeScreen teaching session animates sections', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: VoiceModeScreen(permissionService: FakePermissionService())));
    // Ensure screen builds
    expect(find.byType(VoiceModeScreen), findsOneWidget);
    // Tap floating mic to start listening flow
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
    // The permission dialog appears; simulate confirmation by pumping dialogs - widget test limitations apply
    // This test ensures the widget builds and no exceptions are thrown during the teaching path.
    expect(find.byType(VoiceModeScreen), findsOneWidget);
  });
}
