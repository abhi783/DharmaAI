diff --git a/lib/features/voice/voice_mode_screen.dart b/lib/features/voice/voice_mode_screen.dart
index 9d3b6a1..0000000 100644
--- a/lib/features/voice/voice_mode_screen.dart
+++ b/lib/features/voice/voice_mode_screen.dart
@@
-    final stream = BackendService.instance.streamTeaching(query: userSpeech, style: null);
+    final stream = BackendService.instance.streamTeachingWithReconnect(query: userSpeech, style: null);
     final List<Map<String, Object>> sections = [];
     bool finalReceived = false;
 
     final sub = stream.listen((event) async {
@@
-    }, onDone: () async {
+    }, onDone: () async {
       // Stream ended
-      if (!_interrupted) {
+      if (!_interrupted) {
         // Ask to save session (client-side persistence only)
         if (_currentTeaching != null) {
           final save = await showDialog<bool>(context: context, builder: (c) => AlertDialog(
             title: const Text('Save Learning Session?'),
             content: const Text('Would you like to save this Learning Session to your device?'),
             actions: [
               TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('No')),
               TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Yes')),
             ],
           ));
           if (save == true) {
             await TeachingSessionStorage.instance.saveSession(_currentTeaching!);
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Learning Session saved locally.')));
           }
         }
       }
-      setState(() => _orbController.setState(OrbState.calm));
+      setState(() => _orbController.setState(OrbState.calm));
     }, onError: (e) {
+      // On error (such as network drop) save partial session and show offline
+      // note. Partial save includes collected sections and current index.
+      final partial = {'sections': sections, 'activeIndex': _currentSectionIndex};
+      TeachingSessionStorage.instance.savePartialSession(partial);
+      // show a snackbar to indicate partial saved
+      if (mounted) {
+        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connection lost — partial session saved.')));
+      }
+      setState(() => _orbController.setState(OrbState.calm));
     });
 
     // wait for stream to finish or interruption
     await sub.asFuture();
+    // ensure subscription is cancelled and cleaned up
+    try { await sub.cancel(); } catch (_) {}
   }
@@
   @override
   void dispose() {
-    _partialSub?.cancel();
-    _finalSub?.cancel();
-    _ampSub?.cancel();
+    _partialSub?.cancel();
+    _finalSub?.cancel();
+    _ampSub?.cancel();
+    // Debug: assert no lingering subscriptions
+    assert(() {
+      // nothing to assert here for now; subscriptions are cancelled above
+      return true;
+    }());
     _voice.dispose();
     _orbController.dispose();
     super.dispose();
   }
@@
     final sub = stream.listen((event) async {
@@
     });
 
     // wait for stream to finish or interruption
-    await sub.asFuture();
+    await sub.asFuture();
     // ensure subscription is cancelled and cleaned up
     try { await sub.cancel(); } catch (_) {}
   }
