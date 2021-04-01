import 'package:app_client/screens/AuthScreen/main.dart';
import 'package:app_client/screens/HomeScreen/main.dart';
import 'package:app_client/screens/shared/loading.dart';
import 'package:app_client/screens/shared/message.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String userId;
  SharedPreferences prefs;
  bool error = false;

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
    }).catchError((e) {
      setState(() {
        error = true;
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
    if (prefs == null) {
      return Loading(
        label: 'Checking user...',
      );
    }
    if (error == true) {
      return Message('Sorry, some error ocured', textColor: Colors.red);
    }
    if (userId == null) {
      return Authenticate(changeUser: changeUser);
    } else {
      return HomeScreen(changeUser: changeUser);
    }
  }
}
