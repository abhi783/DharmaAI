import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool v) {
    _busy = v;
    notifyListeners();
  }
}
