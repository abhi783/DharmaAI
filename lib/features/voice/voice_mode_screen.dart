import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/services/permission_service.dart';
import '../../core/services/voice_service.dart';
import '../../core/widgets/dharma_orb.dart';
import '../../core/widgets/waveform_painter.dart';

/// Full-screen immersive voice experience — cinematic and minimal.
class VoiceModeScreen extends StatefulWidget {
  final PermissionService? permissionService;
  final VoiceService? voiceService;
  const VoiceModeScreen({super.key, this.permissionService, this.voiceService});

  @override
  State<VoiceModeScreen> createState() => _VoiceModeScreenState();
}

class _VoiceModeScreenState extends State<VoiceModeScreen> with SingleTickerProviderStateMixin {
  late final PermissionService _perm;
  late final VoiceService _voice;
  late final DharmaOrbController _orbController;
  StreamSubscription<String>? _partialSub;
  StreamSubscription<String>? _finalSub;
  StreamSubscription<double>? _ampSub;
  String _partial = '';
  String _final = '';
  double _amplitude = 0.0;
  bool _listening = false;
  bool _speaking = false;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _perm = widget.permissionService ?? PermissionService();
    _voice = widget.voiceService ?? VoiceService();
    _orbController = DharmaOrbController();
    // initialize voice service (TTS params)
    _voice.init();
  }

  @override
  void dispose() {
    _partialSub?.cancel();
    _finalSub?.cancel();
    _ampSub?.cancel();
    _voice.dispose();
    _orbController.dispose();
    super.dispose();
  }

  Future<void> _startSession() async {
    // Ask for permission only now with a rationale
    final status = await _perm.checkMicrophonePermission();
    if (!status.isGranted) {
      final ok = await showDialog<bool>(context: context, builder: (c) => AlertDialog(
        title: const Text('Microphone required'),
        content: const Text('ధర్మతో మాట్లాడేందుకు మైక్రోఫోన్ అనుమతి అవసరం.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Continue'))
        ],
      ));
      if (ok != true) return;
      final newStatus = await _perm.requestMicrophonePermission();
      if (!newStatus.isGranted) {
        // user denied - show a short explanation
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permission required to talk to Dharma.')));
        return;
      }
    }

    // Start listening
    await _voice.startListening();
    _partialSub = _voice.partialTranscript.listen((t) {
      setState(() => _partial = t);
    });
    _finalSub = _voice.finalTranscript.listen((t) async {
      setState(() {
        _final = t;
        _listening = false;
      });
      // transition to thinking
      await _voice.stopListening();
      _showThinkingSequence();
    });
    _ampSub = _voice.amplitude.listen((a) { setState(() => _amplitude = a); });

    setState(() {
      _listening = true;
      _orbController.setState(OrbState.listening);
    });
  }

  Future<void> _showThinkingSequence() async {
    setState(() => _orbController.setState(OrbState.thinking));
    // show a sequence of banners
    await _showBanner('🧠 Dharma is understanding...');
    await _showBanner('📖 Searching knowledge...');
    await _showBanner('💡 Preparing response...');

    // Simulate speaking (in reality, call backend streaming here)
    setState(() { _speaking = true; _orbController.setState(OrbState.speaking); });
    // Fake streamed response for now — will integrate backend streaming later
    final simulated = 'ఇది ఒక నమూనా ప్రతిస్పందన: ఈ రోజు ధర్మం సారాంశం.';
    await _simulateStreamedResponse(simulated);
    setState(() { _speaking = false; _orbController.setState(OrbState.calm); });
  }

  Future<void> _showBanner(String text) async {
    final overlay = OverlayEntry(builder: (c) => Positioned(top: 120, left: 0, right: 0, child: Center(child: Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    ))));
    Overlay.of(context)?.insert(overlay);
    await Future.delayed(const Duration(milliseconds: 1000));
    overlay.remove();
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _simulateStreamedResponse(String text) async {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      setState(() { _partial = buffer.toString(); });
      await Future.delayed(Duration(milliseconds: 30 + (i % 5) * 10));
    }
    // speak the final response using TTS
    if (!_muted) await _voice.speak(text);
  }

  void _interruptAndListen() async {
    // Stop any TTS and return to listening
    await _voice.stopSpeaking();
    await _voice.startListening();
    setState(() {
      _partial = '';
      _final = '';
      _listening = true;
      _orbController.setState(OrbState.listening);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.95),
      body: SafeArea(
        child: Stack(children: [
          // particles background
          Positioned.fill(child: CustomPaint(painter: _ImmersiveParticlePainter(intensity: _listening || _speaking ? 1.0 : 0.6))),

          // center orb and content
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DharmaOrb(size: 220, controller: _orbController),
              const SizedBox(height: 28),
              if (_listening) ...[
                Text('నేను వింటున్నాను...', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 12),
                SizedBox(height: 48, width: 260, child: CustomPaint(painter: WaveformPainter(amplitude: _amplitude, color: Colors.white70))),
              ] else if (_speaking) ...[
                SizedBox(height: 48, width: 300, child: Text(_partial, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white))),
                const SizedBox(height: 12),
                SizedBox(height: 48, width: 260, child: CustomPaint(painter: WaveformPainter(amplitude: _amplitude, color: Colors.white70))),
              ] else ...[
                Text('హలో — నేను ధర్మను ప్రతినిధించే ఒక ముక్క', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
              ]
            ]),
          ),

          // minimal controls
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _ControlButton(icon: Icons.volume_off, label: 'Mute', onTap: () { setState(() => _muted = !_muted); }),
              _ControlButton(icon: Icons.stop, label: 'Cancel', onTap: () async { await _voice.stopListening(); await _voice.stopSpeaking(); Navigator.of(context).pop(); }),
              _ControlButton(icon: Icons.power_settings_new, label: 'End', onTap: () { Navigator.of(context).pop(); }),
            ]),
          ),

          // floating mic action
          Positioned(
            bottom: 120,
            right: 28,
            child: GestureDetector(
              onTap: () async {
                if (_speaking) {
                  // interrupt
                  _interruptAndListen();
                } else if (_listening) {
                  // stop listening
                  await _voice.stopListening();
                  setState(() { _listening = false; _orbController.setState(OrbState.calm); });
                } else {
                  // start flow
                  await _startSession();
                }
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: Colors.amber[700], shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.22), blurRadius: 18)]),
                child: const Icon(Icons.mic, color: Colors.black, size: 36),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

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

class _ImmersiveParticlePainter extends CustomPainter {
  final double intensity;
  _ImmersiveParticlePainter({this.intensity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.amber.withOpacity(0.02 * intensity);
    final rnd = Random(42);
    final count = (40 * intensity).floor();
    for (int i = 0; i < count; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final r = 0.5 + rnd.nextDouble() * 2.2;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
