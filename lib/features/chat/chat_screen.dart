import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, this.isUser = false});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _ctrl = TextEditingController();
  bool _isSending = false;

  void _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true));
      _isSending = true;
      _ctrl.clear();
    });

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _messages.insert(0, ChatMessage(text: 'Dharma AI reply to: "$text"', isUser: false));
      _isSending = false;
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(child: Text('Start a conversation with Dharma AI', style: Theme.of(context).textTheme.bodyLarge))
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final m = _messages[index];
                      return Align(
                        alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                          decoration: BoxDecoration(
                            color: m.isUser ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(m.text, style: TextStyle(color: m.isUser ? Colors.black : Colors.white)),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.mic)),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.06),
                        hintText: 'Ask in Telugu or English',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _isSending
                      ? const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: CircularProgressIndicator())
                      : FloatingActionButton(
                          onPressed: _send,
                          mini: true,
                          backgroundColor: gold,
                          child: const Icon(Icons.send, color: Colors.black),
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
