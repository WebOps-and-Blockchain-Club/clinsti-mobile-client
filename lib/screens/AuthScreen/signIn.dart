import 'package:app_client/screens/shared/loading.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  final AuthService auth;
  SignIn({this.toggleView, this.auth});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String error;
  final _formKey = GlobalKey<FormState>();
  _signIn() async {
    try {
      setState(() {
        error = null;
      });
      await widget.auth.signIn(_email.text, _password.text);
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
        backgroundColor: Colors.green[400],
        elevation: 0.0,
        title: Text('SignIn'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person_add, color: Colors.white),
            label: Text('SignUp', style: TextStyle(color: Colors.white)),
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
                        icon: Icon(Icons.email),
                        hintText: 'Email',
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
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      controller: _password,
                      validator: (val) =>
                          val.length < 7 ? 'Password did not match' : null,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  ElevatedButton(
                    // style: ButtonStyle(),
                    child: Text(
                      'Login',
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
                        await _signIn();
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
          widget.auth.setToken('newToken');
          widget.auth.notify();
        },
      ),
    );
  }
}
