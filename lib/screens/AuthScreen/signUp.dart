import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  final AuthService auth;
  SignUp({this.toggleView, this.auth});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = '';
  String password = '';
  String name = '';
  _signUp() async {
    widget.auth.signUp('email', 'password', 'name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.purple[100],
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        elevation: 0.0,
        title: Text('Register'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('Login', style: TextStyle(color: Colors.white)),
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
                      icon: Icon(Icons.person),
                      hintText: 'Name',
                      //helperText: 'Enter your Name',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter your name' : null,
                    onChanged: (val) {
                      setState(() => name = val);
                    }),
              ),

              SizedBox(height: 15.0),
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
                      hintText: 'Create Password',
                      //helperText: 'Create a password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val.length < 7
                        ? 'Enter a password 8+ chars long'
                        : null,
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
                  'Register',
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
      // Will be updated via 'Register' Button
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_right_alt),
        onPressed: () async {
          _signUp();
        },
      ),
    );
  }
}
