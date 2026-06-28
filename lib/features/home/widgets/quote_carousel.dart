import 'dart:async';

import 'package:flutter/material.dart';

class QuoteCarousel extends StatefulWidget {
  final List<String> quotes;
  const QuoteCarousel({super.key, required this.quotes});

  @override
  State<QuoteCarousel> createState() => _QuoteCarouselState();
}

class _QuoteCarouselState extends State<QuoteCarousel> {
  int _current = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      setState(() => _current = (_current + 1) % widget.quotes.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (child, anim) => SlideTransition(position: Tween(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(anim), child: FadeTransition(opacity: anim, child: child)),
      child: Container(
        key: ValueKey<int>(_current),
        padding: const EdgeInsets.all(16),
        child: Text(widget.quotes[_current], style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic)),
      ),
    );
  }
}
