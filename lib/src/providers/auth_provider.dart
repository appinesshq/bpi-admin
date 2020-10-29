import 'dart:async';
import 'package:flutter/material.dart';
import '../repositories/bpi_api.dart';

class AuthProvider extends ChangeNotifier {
  final API _api;
  Timer _t;

  AuthProvider(this._api);

  Future<void> authenticate(String email, String password) async {
    try {
      // Authenticate at the backend.
      final expiresAt = await _api.authenticate(email, password);

      // Set a timer to logout automatically when the session expires.
      _t = Timer(expiresAt.difference(DateTime.now()), () {
        logout();
      });

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  logout() {
    // Cancel the timer if it's active.
    if (_t != null) _t.cancel();

    _api.logout();

    notifyListeners();
  }

  bool get authenticated => _api.isAuthenticated;
}
