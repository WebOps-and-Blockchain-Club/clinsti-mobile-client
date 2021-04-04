import 'package:app_client/screens/AuthScreen/main.dart';
import 'package:app_client/screens/HomeScreen/main.dart';
import 'package:app_client/screens/shared/loading.dart';
import 'package:app_client/screens/shared/message.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool error = false;
  bool loading;
  AuthService auth = new AuthService();
  String token;

  notifyWrapp(String tk) {
    setState(() {
      token = tk;
    });
  }

  init() {
    setState(() {
      loading = true;
    });
    auth.init(notifyWrapp).then((value) {
      setState(() {
        token = value;
        loading = false;
      });
    }).catchError((e) {
      setState(() {
        loading = false;
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
    if (loading == true) {
      return Loading(
        label: 'Checking user...',
      );
    }
    if (error == true) {
      return Message('Sorry, some error ocured', textColor: Colors.red);
    }
    if (token == null) {
      return Authenticate(auth: auth);
    } else {
      return HomeScreen(auth: auth);
    }
  }
}
