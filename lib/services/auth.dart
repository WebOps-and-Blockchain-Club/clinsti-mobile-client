import 'dart:convert';
import 'package:http/http.dart';
import 'package:app_client/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class User {
//   final String name;
//   final String email;
//   final String token;
//   User({this.userId, this.name, this.email, this.token});
// }

class AuthService {
  SharedPreferences _auth;
  Function notifyAuth;

  Future<String> init(Function notifyAuth) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _auth = prefs;
      this.notifyAuth = notifyAuth;
      return _auth.getString('token');
    } catch (e) {
      throw ('error');
    }
  }

  void notify() {
    notifyAuth(_auth.getString('token'));
  }

  User _userHTTP(Response res) {
    Map resp = jsonDecode(res.body);
    return resp != null
        ? User(
            name: resp['name'],
            email: resp['email'],
            token: resp['userjwtToken'],
          )
        : null;
  }

  Future<bool> verifyToken() async {
    if (true) {
      return true;
    } else {
      signOut();
      return false;
    }
  }

  String checkToken() {
    return _auth != null ? _auth.getString('token') : null;
  }

  Future<User> getUser() async {
    String token = _auth.getString('token');
    return token != null
        ? User(email: 'abc@abc.com', name: 'abc', token: token)
        : null;
  }

  Future signIn(String email, String password) async {
    try {
      String token = 'newToken';
      _auth.setString('token', token);
      notify();
    } catch (e) {
      throw ('error1');
    }
  }

  Future signUp(String email, String password, String name) async {
    try {
      String token = 'newToken';
      _auth.setString('token', token);
      notify();
    } catch (e) {
      throw ('error2');
    }
  }

  Future signOut() async {
    try {
      _auth.remove('token');
      notify();
    } catch (e) {
      throw ('error3');
    }
  }
}
