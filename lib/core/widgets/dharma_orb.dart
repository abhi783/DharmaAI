import 'dart:math';

import 'package:flutter/material.dart';
import '../../core/widgets/glass_card.dart';

enum OrbState { idle, listening, thinking, speaking, happy, calm, searching, loading }

class DharmaOrbController extends ChangeNotifier {
  OrbState _state = OrbState.idle;
  OrbState get state => _state;

  void setState(OrbState s) {
    _state = s;
    notifyListeners();
  }
}

class DharmaOrb extends StatefulWidget {
  final double size;
  final DharmaOrbController controller;
  const DharmaOrb({super.key, required this.size, required this.controller});

  @override
  State<DharmaOrb> createState() => _DharmaOrbState();
}

class _DharmaOrbState extends State<DharmaOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _breath;
  late final Animation<double> _breathAnim;
  late final Animation<double> _glowAnim;
  late final Animation<double> _rotateAnim;
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))..repeat(reverse: true);
    _breathAnim = CurvedAnimation(parent: _breath, curve: Curves.easeInOut);
    _glowAnim = Tween<double>(begin: 0.8, end: 1.12).animate(_breathAnim);
    _rotateAnim = Tween<double>(begin: -0.02, end: 0.02).animate(_breathAnim);

    widget.controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    double scale = 1.0;
    double halo = 1.0;
    Color coreColor = const Color(0xFFFFE08A);

    switch (state) {
      case OrbState.idle:
        scale = 1.0;
        halo = 1.0;
        break;
      case OrbState.listening:
        scale = 1.06;
        halo = 1.2;
        break;
      case OrbState.thinking:
        scale = 0.98;
        halo = 1.4;
        break;
      case OrbState.speaking:
        scale = 1.08;
        halo = 1.3;
        break;
      case OrbState.happy:
        scale = 1.1;
        halo = 1.45;
        break;
      case OrbState.calm:
        scale = 0.98;
        halo = 0.95;
        break;
      case OrbState.searching:
        scale = 1.0;
        halo = 1.3;
        break;
      case OrbState.loading:
        scale = 0.96;
        halo = 1.25;
        break;
    }

    final size = widget.size;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _breath,
        builder: (context, child) {
          final b = _breathAnim.value;
          final glow = _glowAnim.value;
          final rot = _rotateAnim.value;
          return Transform.rotate(
            angle: rot * (halo),
            child: Stack(alignment: Alignment.center, children: [
              // subtle halo
              CustomPaint(
                size: Size(size, size),
                painter: _HaloPainter(glow: glow * halo, color: coreColor.withOpacity(0.12)),
              ),
              // floating particles
              CustomPaint(
                size: Size(size, size),
                painter: _ParticlePainter(seed: _rand.nextInt(10000), intensity: (b + 0.4) * halo),
              ),
              // core glow
              Container(
                width: size * 0.5 * scale * (0.9 + b * 0.12),
                height: size * 0.5 * scale * (0.9 + b * 0.12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [coreColor, Colors.orangeAccent.withOpacity(0.9)], stops: const [0.0, 1.0]),
                  boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.18 * glow), blurRadius: 28 * glow, spreadRadius: 4 * glow)],
                ),
              ),
              // breathing ring
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(progress: b, thickness: 3.8 * halo),
              ),
            ]),
          );
        },
      ),
    );
  }
}

class _HaloPainter extends CustomPainter {
  final double glow;
  final Color color;
  _HaloPainter({required this.glow, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    final paint = Paint()..shader = RadialGradient(colors: [color.withOpacity(0.25 * glow), Colors.transparent]).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ParticlePainter extends CustomPainter {
  final int seed;
  final double intensity;
  _ParticlePainter({required this.seed, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(seed);
    final count = (8 + (intensity * 6)).floor();
    for (int i = 0; i < count; i++) {
      final angle = rand.nextDouble() * 2 * pi;
      final r = (size.width * 0.28) + rand.nextDouble() * size.width * 0.18 * intensity;
      final x = size.width / 2 + cos(angle) * r;
      final y = size.height / 2 + sin(angle) * r;
      final c = Paint()..color = Colors.amber.withOpacity(0.14 + rand.nextDouble() * 0.12 * intensity);
      final s = 2.0 + rand.nextDouble() * 3.6 * intensity;
      canvas.drawCircle(Offset(x, y), s, c);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double thickness;
  _RingPainter({required this.progress, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.44;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..shader = SweepGradient(colors: [Colors.white.withOpacity(0.09), Colors.orangeAccent.withOpacity(0.24), Colors.white.withOpacity(0.05)], stops: [0.0, progress * 0.8, 1.0]).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
