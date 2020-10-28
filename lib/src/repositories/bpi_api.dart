import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

enum Method { GET, POST, PUT, DELETE }

class API {
  final String _url;
  final String _kid;

  http.Client client;
  String _authToken;
  Timer _t;

  API(
      {String url = 'http://localhost:3000',
      String kid = '54bb2165-71e1-41a6-af3e-7da4a0e1e2c1'})
      : this._url = url,
        this._kid = kid;

  Future<Map<String, dynamic>> doRequest(Method method, String endpoint,
      {Map<String, dynamic> body, Map<String, String> params}) async {
    // Prepare the request headers.
    Map<String, String> headers = {
      HttpHeaders.acceptEncodingHeader: 'application/json',
      HttpHeaders.contentEncodingHeader: 'application/json',
    };
    if (_authToken != '' && _authToken != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $_authToken';
    }

    final url = Uri.http(_url, endpoint, params);

    // Make the request.
    http.Response res;
    try {
      switch (method) {
        case Method.GET:
          res = await http.get(
            url,
            headers: headers,
          );
          break;
        case Method.POST:
          res = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case Method.PUT:
          res = await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case Method.DELETE:
          res = await http.delete(
            url,
            headers: headers,
          );
          break;
      }
    } catch (e) {
      throw e;
    }

    if (res.statusCode >= 300) {
      // TODO: Decode error
      throw res.body.toString();
    }

    return jsonDecode(res.body);
  }

  Future<DateTime> authenticate(String email, String password,
      {bool withTimeout = true}) async {
    final res = await doRequest(Method.GET, 'v1/users/token/$_kid');
    _authToken = res['token'];
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(res['expires_at']);

    if (withTimeout) {
      // Setup a timer for automated logout.
      _t = Timer(expiresAt.difference(DateTime.now()), () {
        logout();
      });
    }

    return expiresAt;
  }

  void logout() {
    if (_t != null) _t.cancel();
    _authToken = null;
  }

  bool get isAuthenticated => _authToken != null && _authToken != "";
}
