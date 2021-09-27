import 'dart:io';

import 'package:app_client/services/server.dart';
import 'package:app_client/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  SharedPreferences _prefs;
  String _token;
  String _verified;
  Server http = new Server();
  User _user;

  String get tokeN => _token ?? null;
  String get verifieD => _verified ?? null;
  User get useR => _user ?? null;

  AuthService() {
    notifyListeners();
    _token = null;
    _verified = null;
    _loadToken();
    _loadVerified();
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

  _loadVerified() async {
    await _initAuth();
    _verified = _prefs.getString('verified') ?? null;
    notifyListeners();
  }

  _setVerified(bool isVerified) async {
    await _initAuth();
    if(isVerified) {
      _prefs.setString('verified', 'true');
      _verified = 'true';
    }
    else {
      _prefs.setString('verified', 'false');
      _verified = 'false';
    }
    notifyListeners();
  }

  _resetVerified() async {
    await _initAuth();
    _prefs.remove('verified');
    _verified = null;
    notifyListeners();
  }

  _setUser(User user) async {
    await _setToken(user.token);
    _user = user;
    notifyListeners();
  }

  _resetUser() async {
    await _resetToken();
    await _resetVerified();
    _user = null;
    notifyListeners();
  }

  Future signIn(String email, String password) async {
    try {
      dynamic obj = await http.signIn(email, password);
      _setToken(obj['userjwtToken']);
      _setVerified(obj["isVerified"]);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future signUp(String email, String password, String name) async {
    try {
      dynamic obj = await http.signUp(email, password, name);
      _setToken(obj['userjwtToken']);
      _setVerified(obj["isVerified"]);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future resendVerificationMail() async {
    await _loadToken();
    try {
      dynamic obj = await http.resendVerificationMail(_token);
      return obj["message"];
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
      dynamic obj = await http.getUserInfo(_token);
      _setUser(obj);
      _setVerified(obj.isVerified);
      return _user;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future updateProfile({String name}) async {
    await _loadToken();
    try {
      await _setUser(
          await http.updateProfile(_token, name: name, email: _user.email));
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

  Future<String> getOTP( String email) async {
    try {
      dynamic obj = await http.getOtp(email);
      return obj["message"];
    } catch (e) {
      throw(e);
    }
  }

  Future resetPassword(String email, String otp, String password) async {
    try{
      dynamic obj = await http.resetPassword(email, otp, password);
      _setToken(obj['message']);
    }
    catch(e) {
      throw(e);
    }
  }

  Future signOut() async {
    await _resetUser();
  }
}
