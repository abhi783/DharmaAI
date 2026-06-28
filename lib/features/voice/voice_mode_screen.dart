import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/services/permission_service.dart';
import '../../core/services/voice_service.dart';
import '../../core/widgets/dharma_orb.dart';
import '../../core/widgets/waveform_painter.dart';
import '../../core/teaching/teaching_engine.dart';
import '../teaching/teaching_session_widget.dart';

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

  TeachingEngine _teachingEngine = TeachingEngine();

  // Teaching session state
  TeachingResponse? _currentTeaching;
  int _currentSectionIndex = -1;
  bool _interrupted = false;

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
      _showThinkingSequenceAndTeach(t);
    });
    _ampSub = _voice.amplitude.listen((a) { setState(() => _amplitude = a); });

    setState(() {
      _partial = '';
      _final = '';
      _listening = true;
      _orbController.setState(OrbState.listening);
    });
  }

  Future<void> _showThinkingSequenceAndTeach(String userSpeech) async {
    setState(() => _orbController.setState(OrbState.thinking));
    // show banners
    await _showBanner('🧠 Dharma is understanding...');
    await _showBanner('📖 Searching knowledge...');
    await _showBanner('💡 Preparing response...');

    // Build teaching response from provider text — for now we use userSpeech to simulate provider
    // In production this should be replaced by server streaming integration (STEP 2)
    final providerText = _mockProviderResponseForQuery(userSpeech);
    final teaching = _teachingEngine.createFromProviderText(providerText: providerText, isScripture: providerText.toLowerCase().contains('gita') || providerText.toLowerCase().contains('భగవద్గీత'));

    setState(() {
      _currentTeaching = teaching;
      _currentSectionIndex = -1;
    });

    // Run teaching session: animate each section and speak it
    await _runTeachingSession(teaching);

    setState(() => _orbController.setState(OrbState.calm));
  }

  Future<void> _runTeachingSession(TeachingResponse teaching) async {
    final sections = _flattenTeachingSections(teaching);
    for (int i = 0; i < sections.length; i++) {
      if (_interrupted) break;
      setState(() {
        _currentSectionIndex = i;
      });
      final text = sections[i]['text'] as String;
      // speak section-by-section
      if (!_muted) {
        final completed = await _voice.speakAndWait(text, timeout: Duration(seconds: max(5, (text.length ~/ 10))));
        if (!completed) {
          // interrupted or timeout
          _interrupted = true;
          break;
        }
      } else {
        // if muted, just wait briefly to allow animation
        await Future.delayed(const Duration(milliseconds: 700));
      }
      // small pause between sections
      await Future.delayed(const Duration(milliseconds: 420));
    }
  }

  List<Map<String, Object>> _flattenTeachingSections(TeachingResponse t) {
    final List<Map<String, Object>> out = [];
    out.add({'title': 'Simple Answer', 'text': t.simpleAnswer});
    out.add({'title': 'Explanation', 'text': t.explanation});
    out.add({'title': 'Example', 'text': t.example});

    if (t.verifiedTeaching != null) {
      out.add({'title': 'Verified Teaching', 'text': t.verifiedTeaching!});
      out.add({'title': 'Traditional Interpretation', 'text': t.traditionalInterpretation ?? ''});
      out.add({'title': 'Modern Application', 'text': t.modernApplication ?? ''});
    }

    out.add({'title': 'Summary', 'text': t.summary});
    out.add({'title': 'Reflection', 'text': t.reflectionQuestion});
    if (t.relatedSuggestion != null) out.add({'title': 'Suggested Next Topic', 'text': t.relatedSuggestion!});
    return out;
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

  String _mockProviderResponseForQuery(String q) {
    // For demo: return a constructed sample that looks like a provider output
    return 'Simple: ధర్మం అనేది కర్తవ్యాన్ని స్వచ్చურად చేయడమనే భావన. Explanation: ధర్మం అంటే మనిది చేయాల్సిన పని, ఫలాలను ఆశించకుండానే. Example: ఒక రైతు రోజుకు పనిచేస్తాడు, అయితే ఫలానికి త్వరగా ఆశించడు. Summary: ధర్మం మనకి జీవితం యొక్క మార్గదర్శకత్వం. Reflection: మీరు ఈ రోజు ఏ చిన్న పని ధర్మంగా చేయగలరు?';
  }

  void _interruptAndListen() async {
    // Stop any TTS and return to listening
    _interrupted = true;
    await _voice.stopSpeaking();
    await _voice.startListening();
    setState(() {
      _partial = '';
      _final = '';
      _listening = true;
      _orbController.setState(OrbState.listening);
      _currentSectionIndex = -1;
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

              // Teaching session view
              if (_currentTeaching != null) ...[
                TeachingSessionWidget(teaching: _currentTeaching!, activeIndex: _currentSectionIndex),
              ] else if (_listening) ...[
                Text('నేను వింటున్నాను...', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 12),
                SizedBox(height: 48, width: 260, child: CustomPaint(painter: WaveformPainter(amplitude: _amplitude, color: Colors.white70))),
              ] else ...[
                Text('హలో — నేనిప్పుడు సిద్ధంగా ఉన్నాను.', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
              ]
            ]),
          ),

          // minimal controls
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _ControlButton(icon: Icons.volume_off, label: _muted ? 'Unmute' : 'Mute', onTap: () { setState(() => _muted = !_muted); }),
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
