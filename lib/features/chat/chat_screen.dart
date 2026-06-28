import 'package:flutter/material.dart';
import '../../core/theme/dharma_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(children: [
          Hero(tag: 'dharma-logo', child: Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [kGold, kGold.withOpacity(0.95)])), child: Center(child: Text('D', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: kDeepBlack, fontWeight: FontWeight.w800)))),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Dharma AI', style: Theme.of(context).textTheme.titleMedium), Text('తెలుగువారి AI మిత్రుడు', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70))])
        ]),
      ),
      body: Column(
        children: [
          Expanded(child: Center(child: Text('Start a meaningful conversation — Ask in Telugu', style: Theme.of(context).textTheme.bodyLarge))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.mic, color: Colors.white70)),
                  Expanded(
                    child: Hero(
                      tag: 'search-hero',
                      child: Material(
                        color: Colors.transparent,
                        child: TextField(
                          controller: _ctrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white10,
                            hintText: 'ఏం తెలుసుకోవాలనుకుంటున్నారు?',
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(onPressed: () {}, mini: true, backgroundColor: kGold, child: const Icon(Icons.send, color: Colors.black)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
