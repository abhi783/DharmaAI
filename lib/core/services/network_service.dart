import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// NetworkService exposes a simple online/offline stream and current state.
class NetworkService {
  NetworkService._private();
  static final NetworkService _instance = NetworkService._private();
  factory NetworkService() => _instance;

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _onlineController = StreamController.broadcast();
  Stream<bool> get onlineStream => _onlineController.stream;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  void init() {
    // check initial status
    _connectivity.checkConnectivity().then((status) {
      _updateFromStatus(status);
    });
    _connectivity.onConnectivityChanged.listen(_updateFromStatus);
  }

  void _updateFromStatus(ConnectivityResult result) {
    final wasOnline = _isOnline;
    _isOnline = (result != ConnectivityResult.none);
    if (wasOnline != _isOnline) {
      _onlineController.add(_isOnline);
    }
  }

  void dispose() {
    _onlineController.close();
  }
}
