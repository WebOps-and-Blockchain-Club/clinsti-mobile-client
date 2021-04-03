import 'package:app_client/services/server.dart';
import 'package:app_client/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  SharedPreferences _auth;
  Function notifyWrapper;
  Server http = new Server();

  Future<String> init(Function notifyWrapp) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _auth = prefs;
      this.notifyWrapper = notifyWrapp;
      return _auth.getString('token');
    } catch (e) {
      throw (e);
    }
  }

  void notify() {
    notifyWrapper(getToken());
  }

  String getToken() {
    return _auth != null ? _auth.getString('token') : null;
  }

  void setToken(String token) {
    try {
      _auth.setString('token', token);
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> verifyToken() async {
    return true;
    // ignore: dead_code
    try {
      await getUserInfo();
      return true;
    } catch (e) {
      signOut();
      return false;
    }
  }

  Future<User> getUserInfo() async {
    String token = getToken();
    try {
      dynamic obj = await http.getUserInfo(token);
      return User(email: obj['email'], name: obj['name'], token: token);
    } catch (e) {
      throw (e);
    }
  }

  Future signIn(String email, String password) async {
    try {
      dynamic obj = await http.signIn(email, password);
      String token = obj['userjwtToken'];
      _auth.setString('token', token);
      notify();
    } catch (e) {
      throw (e);
    }
  }

  Future signUp(String email, String password, String name) async {
    try {
      dynamic obj = await http.signUp(email, password, name);
      setToken(obj['userjwtToken']);
      notify();
    } catch (e) {
      throw (e);
    }
  }

  Future signOut() async {
    try {
      _auth.remove('token');
      notify();
    } catch (e) {
      print(e);
    }
  }
}
