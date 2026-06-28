diff --git a/lib/features/voice/voice_mode_screen.dart b/lib/features/voice/voice_mode_screen.dart
index 8c1b6f5..0000000 100644
--- a/lib/features/voice/voice_mode_screen.dart
+++ b/lib/features/voice/voice_mode_screen.dart
@@
 import '../../core/services/backend_service.dart';
 import '../../core/services/teaching_storage.dart';
+import '../../core/services/network_service.dart';
+import '../../core/widgets/offline_banner.dart';
@@
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.black.withOpacity(0.95),
       body: SafeArea(
         child: Stack(children: [
+          // offline banner
+          const OfflineBanner(),
@@
-    );
+    );
   }
 }
