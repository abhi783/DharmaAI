import 'dart:math';
import 'package:flutter/material.dart';

/// WaveformPainter draws a simple, efficient waveform band that reacts to
/// an amplitude value in the range 0..1. It's intentionally minimal to
/// avoid heavy rebuilds and to remain performant.
class WaveformPainter extends CustomPainter {
  final double amplitude;
  final Color color;

  WaveformPainter({required this.amplitude, this.color = Colors.white70});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.9 * (0.2 + amplitude * 0.8))
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final mid = size.height / 2;
    final w = size.width;
    final rand = Random(42);
    final segments = 24;
    final segW = w / segments;
    for (int i = 0; i < segments; i++) {
      final x = i * segW;
      final phase = sin((i + rand.nextDouble()) * 0.5 + amplitude * 3.0);
      final h = (10 + amplitude * 40) * (0.6 + 0.4 * phase.abs());
      final rect = Rect.fromLTWH(x + segW * 0.15, mid - h / 2, segW * 0.7, h);
      final r = RRect.fromRectAndRadius(rect, const Radius.circular(6));
      canvas.drawRRect(r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) => oldDelegate.amplitude != amplitude;
}
