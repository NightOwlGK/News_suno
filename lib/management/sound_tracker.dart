import 'package:flutter/material.dart';

class SoundTracker extends ChangeNotifier {
  bool _isClicked = false;

  bool getClicked() => _isClicked;

  void clicked() {
    _isClicked = !_isClicked;
    notifyListeners();
  }

  void doFalse() {
    _isClicked = false;
    notifyListeners();
  }
}
