import 'package:app_client/dev/dev.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn(this.toggleView);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String error;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  _signIn(AuthService auth) async {
    setState(() {
      error = null;
      loading = true;
    });
    try {
      await auth.signIn(_email.text, _password.text);
    } catch (e) {
      setState(() {
        error = e.toString();
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
                backgroundColor: Colors.green[400],
                elevation: 0.0,
                title: Text('SignIn'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.ac_unit_rounded),
                      onPressed: (() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Link()));
                      })),
                  TextButton.icon(
                    icon: Icon(Icons.person_add, color: Colors.white),
                    label:
                        Text('SignUp', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      widget.toggleView();
                    },
                  ),
                ],
              ),
              body:loading? Center(child: CircularProgressIndicator(),): Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/bg1.jpg'),
                          fit: BoxFit.cover)),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
                                  icon: Icon(Icons.email),
                                  hintText: 'Email',
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
                                  hintText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                                controller: _password,
                                validator: (val) => val.length < 7
                                    ? 'Password did not match'
                                    : null,
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
                                  await _signIn(auth);
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
            ));
  }
}
