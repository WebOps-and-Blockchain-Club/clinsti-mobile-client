import 'package:app_client/screens/AuthScreen/main.dart';
import 'package:app_client/screens/HomeScreen/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String userId;
  SharedPreferences prefs;

  changeUser() {
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  init() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        prefs = value;
        userId = prefs.getString('userId');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Authenticate(changeUser: changeUser);
    } else {
      return HomeScreen(changeUser: changeUser);
    }
  }
}
