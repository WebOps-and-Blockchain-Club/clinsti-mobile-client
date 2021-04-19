import 'package:app_client/services/server.dart';
import 'package:app_client/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  SharedPreferences _auth;
  String _token;
  Server http = new Server();

  String get token => _token;

  AuthService() {
    _token = null;
    _loadToken();
  }

  _initAuth() async {
    if (_auth == null) _auth = await SharedPreferences.getInstance();
  }

  _loadToken() async {
    await _initAuth();
    _token = _auth.getString('token') ?? null;
    notifyListeners();
  }

  _setToken(String token) async {
    await _initAuth();
    _auth.setString('token', token);
    _loadToken();
  }

  _resetoken() async {
    await _initAuth();
    _auth.remove('token');
    _loadToken();
  }

  Future<bool> verifyToken() async {
    return true;
    // ignore: dead_code
    //
    try {
      await getUserInfo();
      return true;
    } catch (e) {
      signOut();
      return false;
    }
  }

  Future signIn(String email, String password) async {
    try {
      dynamic obj = await http.signIn(email, password);
      _setToken(obj['userjwtToken']);
    } catch (e) {
      throw (e);
    }
  }

  Future signUp(String email, String password, String name) async {
    try {
      dynamic obj = await http.signUp(email, password, name);
      _setToken(obj['userjwtToken']);
    } catch (e) {
      throw (e);
    }
  }

  Future<User> getUserInfo() async {
    _loadToken();
    try {
      User user = await http.getUserInfo(_token);
      return user;
    } catch (e) {
      throw (e);
    }
  }

  Future<User> getUpdatedProfile({String name, String email}) async {
    _loadToken();
    try{
      User user = await http.updateProfile(token, name: name, email: email);
      return user;
    }
    catch (e) {
      throw(e);
    }
  }

  Future signAnon() async {
    _setToken('asdasdas');
  }

  Future signOut() async {
    await _resetoken();
  }
}
