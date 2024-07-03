import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  int? _randomId;

  bool get isLoggedIn => _isLoggedIn;
  int? get randomId => _randomId;

  void login(int? randomId) {
    _isLoggedIn = true;
    _randomId = randomId;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _randomId = null; // Reset random ID
    notifyListeners();
  }
}
