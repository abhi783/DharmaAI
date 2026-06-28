import 'package:flutter/material.dart';
import '../../core/services/network_service.dart';

class OfflineBanner extends StatefulWidget {
  final String message;
  final VoidCallback? onRetry;
  const OfflineBanner({super.key, this.message = 'You are offline — reconnect to continue.', this.onRetry});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  late final NetworkService _net;
  bool _online = true;
  StreamSubscription<bool>? _sub;

  @override
  void initState() {
    super.initState();
    _net = NetworkService();
    _net.init();
    _online = _net.isOnline;
    _sub = _net.onlineStream.listen((v) { setState(() { _online = v; }); });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_online) return const SizedBox.shrink();
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.redAccent,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(children: [
              const Icon(Icons.cloud_off, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
              TextButton(onPressed: widget.onRetry ?? () { BackendService.instance.requestImmediateReconnect(); }, child: const Text('Retry', style: TextStyle(color: Colors.white)))
            ]),
          ),
        ),
      ),
    );
  }
}
