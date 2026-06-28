import 'package:flutter/material.dart';

class HeaderArcPainter extends CustomPainter {
  final Color gold;
  HeaderArcPainter({required this.gold});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 1.8);
    final Gradient gradient = LinearGradient(
      colors: [gold.withOpacity(0.18), gold.withOpacity(0.06)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final Paint paint = Paint()..shader = gradient.createShader(rect);

    final Path path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.2, size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);

    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = Colors.white.withOpacity(0.03);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
