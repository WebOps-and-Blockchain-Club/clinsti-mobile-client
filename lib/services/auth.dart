import 'dart:io';

import 'package:app_client/services/server.dart';
import 'package:app_client/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  SharedPreferences _prefs;
  String _token;
  Server http = new Server();
  User _user;

  String get tokeN => _token ?? null;
  User get useR => _user ?? null;

  AuthService() {
    notifyListeners();
    _token = null;
    _loadToken();
  }

  _initAuth() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  _loadToken() async {
    await _initAuth();
    _token = _prefs.getString('token') ?? null;
    notifyListeners();
  }

  _setToken(String token) async {
    await _initAuth();
    _prefs.setString('token', token);
    _token = token;
    notifyListeners();
  }

  _resetToken() async {
    await _initAuth();
    _prefs.remove('token');
    _token = null;
    notifyListeners();
  }

  _setUser(User user) async {
    await _setToken(user.token);
    _user = user;
    notifyListeners();
  }

  _resetUser() async {
    await _resetToken();
    _user = null;
    notifyListeners();
  }

  Future signIn(String email, String password) async {
    try {
      dynamic obj = await http.signIn(email, password);
      _setToken(obj['userjwtToken']);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future signUp(String email, String password, String name) async {
    try {
      dynamic obj = await http.signUp(email, password, name);
      _setToken(obj['userjwtToken']);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<User> verifyToken() async {
    await _loadToken();
    try {
      User user = await getUserInfo();
      return user;
    } on SocketException {
      print('connection');
      throw SocketException('Connection Error');
    } catch (e) {
      print(e);
      signOut();
      throw 'Session expired';
    }
  }

  Future<User> getUserInfo() async {
    await _loadToken();
    try {
      _setUser(await http.getUserInfo(_token));
      return _user;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future updateProfile({String name, String email}) async {
    await _loadToken();
    try {
      await _setUser(
          await http.updateProfile(_token, name: name, email: email));
    } catch (e) {
      throw (e);
    }
  }

  Future changePassword(String oldPassword, String newPassword) async{
    await _loadToken();
    try{
      dynamic obj = await http.changePassword(_token, oldPassword, newPassword);
      _setToken(obj['userjwtToken']);
      _user.token = _token;
    }
    catch(e) {
      throw(e);
    }
  }

  Future signOut() async {
    await _resetUser();
  }
}
