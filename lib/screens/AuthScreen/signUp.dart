import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  final Function changeUser;
  SignUp({this.toggleView, this.changeUser});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  _signUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', 'Hello');
    widget.changeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                widget.toggleView();
              }),
        ],
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_right_alt),
        onPressed: () async {
          _signUp();
        },
      ),
    );
  }
}
