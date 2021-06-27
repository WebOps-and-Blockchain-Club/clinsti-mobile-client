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
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    color: Colors.white,
                                  )),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 70,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: AssetImage('assets/82.png'),
                                        fit: BoxFit.cover)),
                              ),
                              Text(
                                'Welcome',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Create an Account',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Column(
                                children: [
                                  Form(
                                      key: _formKey,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 10.0),
                                          Material(
                                            elevation: 20.0,
                                            shadowColor: Colors.white,
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                const Radius.circular(10.0)),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.person,
                                                    color: Colors.green),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.0),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                const Radius
                                                                        .circular(
                                                                    10.0))),
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    const Radius.circular(10.0),
                                                  ),
                                                ),
                                                hintText: 'Name',
                                              ),
                                              maxLines: null,
                                              controller: _name,
                                              validator: (val) => val.isEmpty
                                                  ? 'Please enter your name'
                                                  : null,
                                            ),
                                          ),
                                          SizedBox(height: 15.0),
                                          Material(
                                            elevation: 20.0,
                                            shadowColor: Colors.white,
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                const Radius.circular(10.0)),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.email,
                                                    color: Colors.green),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.0),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                const Radius
                                                                        .circular(
                                                                    10.0))),
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    const Radius.circular(10.0),
                                                  ),
                                                ),
                                                hintText: 'Email',
                                              ),
                                              maxLines: null,
                                              controller: _email,
                                              validator: (val) => val.isEmpty
                                                  ? 'Please enter your email'
                                                  : null,
                                            ),
                                          ),
                                          SizedBox(height: 15.0),
                                          Material(
                                            elevation: 20.0,
                                            shadowColor: Colors.white,
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                const Radius.circular(10.0)),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.create_rounded,
                                                    color: Colors.green,
                                                  ),
                                                  hintText: 'Create Password',
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  const Radius
                                                                          .circular(
                                                                      10.0))),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      const Radius.circular(
                                                          10.0),
                                                    ),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _obscureText1
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Colors.grey[600],
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _obscureText1 =
                                                            !_obscureText1;
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
                                          Material(
                                            elevation: 20.0,
                                            shadowColor: Colors.white,
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                const Radius.circular(10.0)),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.create_rounded,
                                                    color: Colors.green,
                                                  ),
                                                  hintText: 'Confirm Password',
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  const Radius
                                                                          .circular(
                                                                      10.0))),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      const Radius.circular(
                                                          10.0),
                                                    ),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _obscureText2
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Colors.grey[600],
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _obscureText2 =
                                                            !_obscureText2;
                                                      });
                                                    },
                                                  )),
                                              controller: _confirmpass,
                                              validator: (val) {
                                                if (val.isEmpty) {
                                                  return "Please Re-Enter New Password";
                                                } else if (val.length < 8) {
                                                  return "Password must be atleast 8 characters long";
                                                } else if (val !=
                                                    _password.text) {
                                                  return "Password must be same as above";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              obscureText: _obscureText2,
                                            ),
                                          ),
                                          SizedBox(height: 15.0),
                                          Center(
                                            child: ElevatedButton.icon(
                                              icon: ImageIcon(
                                                AssetImage(
                                                    "assets/sign_up_icon.png"),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        10),
                                              ),
                                              label: Text(
                                                'Register',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  await _signUp(auth);
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 6.0),
                                          error != null
                                              ? Text(
                                                  error,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  "Already have an Account ? "),
                                              GestureDetector(
                                                onTap: widget.toggleView,
                                                child: Text(
                                                  "Sign in",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 60,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
      ),
    );
  }
}
