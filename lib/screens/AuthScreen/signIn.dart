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
  // text field state
  String email = '';
  String password = '';

  _signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', 'Hello');
    widget.changeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 0.0,
        title: Text('Login'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person_add, color: Colors.white),
            label: Text('Register', style: TextStyle(color: Colors.white)),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Form(
              //key: _formkey, // gives info abt any change in form fields
              child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'Email',
                      //helperText: 'Enter your email',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter your email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    }),
              ),

              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.create_rounded),
                      hintText: 'Password',
                      //helperText: 'Create a password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val.length < 7 ? 'Password did not match' : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    }),
              ),
              SizedBox(height: 15.0),
              // ignore: deprecated_member_use
              RaisedButton(
                color: Colors.red,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  // We define our own validator for each form and use
                  // built in 'validate'.
                  //if (_formkey.currentState.validate()) {}
                },
              ),
              SizedBox(height: 6.0),
            ],
          ))),

      // This is a sample button to debug Home and Add complaint screen
      // Will be updated via 'Login' Button
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_right_alt),
        onPressed: () async {
          _signIn();
        },
      ),
    );
  }
}
