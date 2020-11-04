import 'dart:async';
import 'package:flutter/material.dart';
import '../repositories/api.dart';
import '../models/session.dart';
export '../models/session.dart';

class AuthProvider extends ChangeNotifier {
  final API _api;
  Session _session;
  Timer _t;

  AuthProvider(this._api);

  Future<void> authenticate(String email, String password) async {
    try {
      // Authenticate at the backend.
      _session = await _api.authenticate(email, password, withUser: true);

      // Set a timer to logout automatically when the session expires.
      _t = Timer(session.expiresAt.difference(DateTime.now()), () {
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
    _session = null;

    notifyListeners();
  }

  bool get authenticated => _session != null;
  Session get session => _session;
}
