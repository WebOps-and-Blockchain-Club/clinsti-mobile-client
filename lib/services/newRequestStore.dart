import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NewRequestStore {
  SharedPreferences _prefs;
  Object storedComplaint = {};
  init() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  getStoredRequest() async {
    try {
      await init();
      String jsonString = _prefs.getString('storedRequest');
      storedComplaint = await jsonDecode(jsonString);
      return storedComplaint;
    } catch (e) {
      return null;
    }
  }

  setStoredRequest(dynamic newRequest) async {
    try {
      await init();
      String jsonString = jsonEncode(newRequest);
      _prefs.setString('storedRequest', jsonString);
    } catch (e) {}
  }

  deleteRequest() async {
    try {
      await init();
      _prefs.remove('storedRequest');
    } catch (e) {}
  }
}
