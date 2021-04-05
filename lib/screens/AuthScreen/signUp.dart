import 'package:app_client/screens/shared/loading.dart';
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
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  String error;
  final _formKey = GlobalKey<FormState>();
  _signUp() async {
    setState(() {
      error = null;
    });
    try {
      widget.auth.signUp(_email.text, _password.text, _name.text);
    } catch (e) {
      setState(() {
        error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        elevation: 0.0,
        title: Text('SignUp'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('SignIn', style: TextStyle(color: Colors.white)),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Form(
              key: _formKey,
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
                      controller: _name,
                      validator: (val) =>
                          val.isEmpty ? 'Please enter your name' : null,
                    ),
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
                      controller: _email,
                      validator: (val) =>
                          val.isEmpty ? 'Please enter your email' : null,
                    ),
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
                      controller: _password,
                      validator: (val) => val.length < 7
                          ? 'Enter a password 8+ chars long'
                          : null,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return Loading(
                                backgroundColor: Color.fromRGBO(0, 0, 2, 0.4),
                              );
                            }));
                        await _signUp();
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(height: 6.0),
                  error != null
                      ? Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        )
                      : SizedBox()
                ],
              ))),
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_right_alt),
        onPressed: () async {
          widget.auth.setToken('oldToken');
          widget.auth.notify();
        },
      ),
    );
  }
}
