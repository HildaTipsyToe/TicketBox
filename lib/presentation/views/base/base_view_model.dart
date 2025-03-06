import 'package:flutter/material.dart';


class BaseViewModel extends ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;

  bool hasError = false;
  String? errorMsg;

  void setBusy(bool value) async {
    if (_busy != value) {
      _busy = value;
      notifyListeners();
    }
  }

  bool _mounted = true;

  bool get mounted => _mounted;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }
  
}
