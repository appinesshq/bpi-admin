import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository api;

  List<User> _users;
  User _user;
  int _page = 1;
  final int _rows;

  UserProvider(this.api, {int rows = 25}) : _rows = rows;

  // TODO: Register

  // Future<User> register() async {
  //   _user = await api.registerUser(_email, _password, _confirmPassword);
  //   notifyListeners();
  //   return _user;
  // }

  // TODO: Create

  Future<UnmodifiableListView<User>> fetch(
      {int page = 1, bool force = false}) async {
    // Fetch the users from the backend when:
    // - calling for the first time
    // - switching pages
    // - force is enabled
    if (_users == null || page != _page || force) {
      _users = await api.fetchUsers(page, _rows);
      _page = page;
      notifyListeners();
    }

    return UnmodifiableListView(_users);
  }

  Future<User> get(String id) async {
    _user = await api.getUser(id);
    notifyListeners();
    return _user;
  }

  // TODO: Update
  // TODO: Delete

  // Getters.
  UnmodifiableListView<User> get users => UnmodifiableListView(_users);
  User get user => _user;
  int get page => _page;
}
