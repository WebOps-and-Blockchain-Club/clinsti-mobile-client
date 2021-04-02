import 'package:app_client/screens/AuthScreen/signIn.dart';
import 'package:app_client/screens/AuthScreen/signUp.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  final AuthService auth;
  Authenticate({this.auth});
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
      return SignIn(toggleView: toggleView, auth: widget.auth);
    } else {
      return SignUp(toggleView: toggleView, auth: widget.auth);
    }
  }
}
