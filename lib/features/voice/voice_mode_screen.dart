@@
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.black.withOpacity(0.95),
       body: SafeArea(
         child: Stack(children: [
@@
-          // minimal controls
-          Positioned(
-            bottom: 40,
-            left: 24,
-            right: 24,
-            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
-              _ControlButton(icon: Icons.volume_off, label: _muted ? 'Unmute' : 'Mute', onTap: () { setState(() => _muted = !_muted); }),
-              _ControlButton(icon: Icons.stop, label: 'Cancel', onTap: () async { await _voice.stopListening(); await _voice.stopSpeaking(); Navigator.of(context).pop(); }),
-              _ControlButton(icon: Icons.power_settings_new, label: 'End', onTap: () { Navigator.of(context).pop(); }),
-            ]),
-          ),
+          // minimal controls
+          Positioned(
+            bottom: 40,
+            left: 24,
+            right: 24,
+            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
+              Semantics(button: true, label: _muted ? 'Unmute' : 'Mute', hint: 'Toggle sound', child: _ControlButton(icon: Icons.volume_off, label: _muted ? 'Unmute' : 'Mute', onTap: () { setState(() => _muted = !_muted); })),
+              Semantics(button: true, label: 'Cancel', hint: 'Cancel current session', child: _ControlButton(icon: Icons.stop, label: 'Cancel', onTap: () async { await _voice.stopListening(); await _voice.stopSpeaking(); Navigator.of(context).pop(); })),
+              Semantics(button: true, label: 'End Conversation', hint: 'End and exit voice mode', child: _ControlButton(icon: Icons.power_settings_new, label: 'End', onTap: () { Navigator.of(context).pop(); })),
+            ]),
+          ),
@@
-            child: GestureDetector(
-              onTap: () async {
-                if (_speaking) {
-                  // interrupt
-                  _interruptAndListen();
-                } else if (_listening) {
-                  // stop listening
-                  await _voice.stopListening();
-                  setState(() { _listening = false; _orbController.setState(OrbState.calm); });
-                } else {
-                  // start flow
-                  await _startSession();
-                }
-              },
-              child: Container(
-                width: 72,
-                height: 72,
-                decoration: BoxDecoration(color: Colors.amber[700], shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.22), blurRadius: 18)]),
-                child: const Icon(Icons.mic, color: Colors.black, size: 36),
-              ),
-            ),
+            child: GestureDetector(
+              onTap: () async {
+                if (_speaking) {
+                  // interrupt
+                  _interruptAndListen();
+                } else if (_listening) {
+                  // stop listening
+                  await _voice.stopListening();
+                  setState(() { _listening = false; _orbController.setState(OrbState.calm); });
+                } else {
+                  // start flow
+                  await _startSession();
+                }
+              },
+              child: Semantics(
+                button: true,
+                label: 'Microphone',
+                hint: 'Tap to start or interrupt listening',
+                child: Container(
+                  width: 72,
+                  height: 72,
+                  decoration: BoxDecoration(color: Colors.amber[700], shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.22), blurRadius: 18)]),
+                  child: const Icon(Icons.mic, color: Colors.black, size: 36),
+                ),
+              ),
+            ),
           ),
         ]),
       ),
     );
   }
 }
@@
 class _ControlButton extends StatelessWidget {
   final IconData icon;
   final String label;
   final VoidCallback onTap;
   const _ControlButton({required this.icon, required this.label, required this.onTap});
 
   @override
   Widget build(BuildContext context) {
     return InkWell(
       onTap: onTap,
       borderRadius: BorderRadius.circular(14),
       child: Container(
         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
         decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(14)),
         child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: Colors.white), const SizedBox(height: 6), Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))]),
       ),
     );
   }
 }
