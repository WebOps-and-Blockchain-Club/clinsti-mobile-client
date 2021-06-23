import 'package:app_client/dev/dev.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  String error;
  bool loading = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  final _formKey = GlobalKey<FormState>();
  _signUp(auth) async {
    setState(() {
      error = null;
      loading = true;
    });
    try {
      await auth.signUp(_email.text, _password.text, _name.text);
    } catch (e) {
      setState(() {
        error = e;
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[400],
          elevation: 0.0,
          title: Text('SignUp'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.ac_unit_rounded),
                onPressed: (() {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Link()));
                })),
            TextButton.icon(
              icon: Icon(Icons.person, color: Colors.white),
              label: Text('SignIn', style: TextStyle(color: Colors.white)),
              onPressed: () {
                widget.toggleView();
              },
            ),
          ],
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.email),
                                hintText: 'Email',
                                //helperText: 'Enter your email',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: null,
                              controller: _email,
                              validator: (val) => val.isEmpty
                                  ? 'Please enter your email'
                                  : null,
                            ),
                          ),

                          SizedBox(height: 15.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  icon: Icon(Icons.create_rounded),
                                  hintText: 'Create Password',
                                  //helperText: 'Create a password',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText1
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText1 = !_obscureText1;
                                      });
                                    },
                                  )),
                              controller: _password,
                              validator: (val) => val.length < 7
                                  ? 'Enter a password 8+ chars long'
                                  : null,
                              obscureText: _obscureText1,
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  icon: Icon(Icons.create_rounded),
                                  hintText: 'Confirm Password',
                                  //helperText: 'Confirm password',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText2
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText2 = !_obscureText2;
                                      });
                                    },
                                  )),
                              controller: _confirmpass,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Please Re-Enter New Password";
                                } else if (val.length < 8) {
                                  return "Password must be atleast 8 characters long";
                                } else if (val != _password.text) {
                                  return "Password must be same as above";
                                } else {
                                  return null;
                                }
                              },
                              obscureText: _obscureText2,
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
                                await _signUp(auth);
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
                      )),
                )),
      ),
    );
  }
}

