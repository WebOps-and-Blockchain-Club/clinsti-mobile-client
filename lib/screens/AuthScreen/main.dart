import 'package:app_client/screens/AuthScreen/signIn.dart';
import 'package:app_client/screens/AuthScreen/signUp.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  final Function setEmail;

  const Authenticate({Key? key, required this.setEmail}) : super(key: key);
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      return SignUp(toggleView, widget.setEmail);
    }
  }
}
