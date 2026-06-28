import 'package:flutter/material.dart';

class AnimatedScaleTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const AnimatedScaleTap({super.key, required this.child, this.onTap});

  @override
  State<AnimatedScaleTap> createState() => _AnimatedScaleTapState();
}

class _AnimatedScaleTapState extends State<AnimatedScaleTap> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 150), lowerBound: 0.0, upperBound: 0.05);
    _anim = CurvedAnimation(parent: _c, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _c.forward();
  void _onTapUp(_) => _c.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapCancel: () => _c.reverse(),
      onTapUp: _onTapUp,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) => Transform.scale(scale: 1 - _anim.value, child: child),
        child: widget.child,
      ),
    );
  }
}
