import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  final Function changeUser;
  SignIn({this.toggleView, this.changeUser});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  _signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', 'Hello');
    widget.changeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignIn'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.sync),
              onPressed: () {
                widget.toggleView();
              }),
        ],
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_right_alt),
        onPressed: () async {
          _signIn();
        },
      ),
    );
  }
}
