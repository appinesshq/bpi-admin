import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Request;
import '../models/session.dart';
import '../repositories/repositories.dart';

class API implements AuthRepository, UserRepository {
  String url;
  int version;
  String kid;
  bool debug = false;
  Client client;

  String _token;

  Future<dynamic> _request(
    String endpoint, {
    String method: 'get',
    bool registration: false,
    bool basic: false,
    String login: '',
    String password: '',
    String body,
  }) async {
    if (!registration && !basic && _token == null) throw ('Token is null');
    if (!registration && basic && (login.isEmpty || password.isEmpty))
      throw ('Login and password are required with non-bearer authentication');

    final authorization = basic
        ? 'Basic ' + base64Encode(utf8.encode('$login:$password'))
        : 'Bearer $_token';
    Request request = Request(method, Uri.parse('$url/v$version/$endpoint'));
    request.headers['Authorization'] = authorization;
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = body;
    }

    if (debug) {
      print('request: {$request} headers: ${request.headers}');
    }

    final response = await client.send(request);
    final responseBody = await response.stream.bytesToString();
    if (responseBody == null || responseBody == '') {
      if (response.statusCode >= 400)
        throw ('Unexpected status ${response.statusCode}');
      return null;
    }

    final data = json.decode(responseBody);
    if (response.statusCode >= 400)
      throw (data['error'] ?? 'Unexpected status ${response.statusCode}');

    if (debug) {
      print('response: {$data}');
    }

    return data;
  }

  Future<Session> authenticate(String login, String password,
      {bool withUser: false}) async {
    final Map<String, dynamic> data = await _request('users/token/$kid',
        basic: true, login: login, password: password);
    _token = data['token'];

    if (withUser) {
      final user = await getUser('me');
      return Session.fromJson(data, user: user);
    }

    return Session.fromJson(data);
  }

  void logout() {
    _token = null;
  }

  bool get isAuthenticated => _token != null && _token.isNotEmpty;

  // Future<User> registerUser(String email, String password, String passwordConfirm) async {
  //   print('API CALL to register user');
  //   final data = await _request(
  //     'users',
  //     registration: true,
  //     method: 'post',
  //     body: json.encode({
  //       'email': email,
  //       'password': password,
  //       'password_confirm': passwordConfirm,
  //     }),
  //   );

  //   return User.fromJson(data);
  // }

  Future<User> createUser(String email, String password, String passwordConfirm,
      List<UserRole> roles) async {
    final data = await _request(
      'users',
      method: 'post',
      body: json.encode({
        'email': email,
        'roles': roles.map((role) => role.toString()).toList(),
        'password': password,
        'password_confirm': passwordConfirm,
      }),
    );

    return User.fromJson(data);
  }

  Future<List<User>> fetchUsers(int page, int rows) async {
    final List<dynamic> data =
        await _request('users/$page/$rows', method: 'get');

    var users = List<User>();
    data.forEach((user) {
      users.add(User.fromJson(user));
    });

    return users;
  }

  Future<User> getUser(String q) async {
    final data = await _request('users/$q', method: 'get');
    return User.fromJson(data);
  }

  Future<User> updateUser(User user,
      {String password, String passwordConfirm}) async {
    // Get the current user data.
    final u = await getUser(user.id);

    final data = await _request(
      'users',
      method: 'put',
      body: json.encode({
        'email': u.email != user.email ? user.email : null,
        'roles': u.roles != user.roles
            ? user.roles.map((role) => role.toString()).toList()
            : null,
        'password': password,
        'password_confirm': passwordConfirm,
      }),
    );

    return User.fromJson(data);
  }

  Future<void> deleteUser(String id) async {
    await _request('user/$id', method: 'delete');
  }

  API(
      {this.url = 'http://localhost:3000',
      this.version = 1,
      this.kid = '54bb2165-71e1-41a6-af3e-7da4a0e1e2c1'})
      : client = Client();
}
