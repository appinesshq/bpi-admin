import '../models/session.dart';

abstract class AuthRepository {
  Future<Session> authenticate(String login, String password,
      {bool withUser: false});
}
