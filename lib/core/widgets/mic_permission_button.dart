import 'package:flutter/material.dart';
import '../../core/services/permission_service.dart';

class MicPermissionButton extends StatefulWidget {
  final String label;
  const MicPermissionButton({super.key, this.label = 'Enable Microphone'});

  @override
  State<MicPermissionButton> createState() => _MicPermissionButtonState();
}

class _MicPermissionButtonState extends State<MicPermissionButton> {
  final PermissionService _perm = PermissionService();
  String _statusText = 'Unknown';

  @override
  void initState() {
    super.initState();
    _updateStatus();
  }

  Future<void> _updateStatus() async {
    final s = await _perm.checkMicrophonePermission();
    setState(() {
      _statusText = s.isGranted ? 'Granted' : (s.isDenied ? 'Denied' : 'Unknown');
    });
  }

  Future<void> _request() async {
    final s = await _perm.requestMicrophonePermission();
    if (!mounted) return;
    setState(() { _statusText = s.isGranted ? 'Granted' : (s.isPermanentlyDenied ? 'Permanently denied' : 'Denied'); });
    if (s.isPermanentlyDenied) {
      // show dialog to guide user to settings
      showDialog(context: context, builder: (c) => AlertDialog(
        title: const Text('Microphone permission required'),
        content: const Text('Please enable the microphone permission in app settings to use voice features.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('Cancel')),
          TextButton(onPressed: () { PermissionService().openAppSettings(); Navigator.of(c).pop(); }, child: const Text('Open Settings'))
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _request,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.mic),
        const SizedBox(width: 8),
        Text(widget.label),
        const SizedBox(width: 12),
        Text('($_statusText)', style: const TextStyle(fontSize: 12)),
      ]),
    );
  }
}
