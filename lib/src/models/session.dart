import 'dart:convert';
import 'user.dart';
export 'user.dart';

class Session {
  final String token;
  final DateTime expiresAt;
  final User user;

  Session(token, expiresAt, {User user})
      : user = user,
        token = token,
        expiresAt = expiresAt;

  Session.fromJson(Map<String, dynamic> data, {User user})
      : user = data['user'] != null ? User.fromJson(data['user']) : user,
        token = data['token'],
        expiresAt = DateTime.fromMillisecondsSinceEpoch(
            1000 * (data['expires_at'] as int));

  String toJson() {
    return json.encode(<String, dynamic>{
      'token': token,
      'expires_at': expiresAt,
      'user': user.toJson(),
    });
  }
}
