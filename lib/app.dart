import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/dharma_theme.dart';
import 'features/root/root_scaffold.dart';
import 'features/life/life_screen.dart';

class DharmaApp extends StatelessWidget {
  const DharmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dharma AI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeAnimationDuration: const Duration(milliseconds: 400),
      home: const StartupScreenWrapper(),
    );
  }
}

class StartupScreenWrapper extends StatefulWidget {
  const StartupScreenWrapper({super.key});

  @override
  State<StartupScreenWrapper> createState() => _StartupScreenWrapperState();
}

class _StartupScreenWrapperState extends State<StartupScreenWrapper> {
  @override
  Widget build(BuildContext context) {
    return const _StartupScreen();
  }
}

class _StartupScreen extends StatefulWidget {
  const _StartupScreen({super.key});

  @override
  State<_StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<_StartupScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
    _fadeIn = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward();

    // navigate after cinematic
    Future.delayed(const Duration(milliseconds: 3400), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const RootScaffold()));
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kDeepBlack,
      body: FadeTransition(
        opacity: _fadeIn,
        child: Stack(children: [
          // particles background - simple subtle dots
          Positioned.fill(child: CustomPaint(painter: _StartupParticlePainter())),
          // center orb and text
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: 220,
                height: 220,
                child: Center(child: Builder(builder: (c) {
                  final controller = null; // orb can be animated standalone here
                  return const SizedBox.shrink();
                })),
              ),
              const SizedBox(height: 28),
              Text('ధర్మ', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('తెలుగువారి AI మిత్రుడు', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _StartupParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.amber.withOpacity(0.03);
    final rnd = Random(42);
    for (int i = 0; i < 60; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final r = 0.6 + rnd.nextDouble() * 2.2;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
