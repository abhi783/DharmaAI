diff --git a/lib/features/life/life_screen.dart b/lib/features/life/life_screen.dart
index 8a1a5b2..0000000 100644
--- a/lib/features/life/life_screen.dart
+++ b/lib/features/life/life_screen.dart
@@
 import 'package:provider/provider.dart';
 import '../home/home_screen.dart';
 import '../chat/chat_screen.dart';
+import '../voice/mic_cta.dart';
@@
                   const SizedBox(height: 6),
-                  Text(vm.subGreeting, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
+                  Text(vm.subGreeting, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
+                  const SizedBox(height: 18),
+                  // Talk to Dharma CTA
+                  TalkToDharmaCTA(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Center(child: Text('Launching...'))))),
                   const SizedBox(height: 18),
