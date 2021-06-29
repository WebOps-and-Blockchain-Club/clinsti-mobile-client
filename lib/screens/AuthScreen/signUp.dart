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
  bool nameerror = false;
  bool emailerror = false;
  bool passerror = false;
  bool confirmpassemptyerror = false;
  bool confirmpasslesserro = false;
  bool confirmpassnomatcherror = false;
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
                                          Stack(
                                            children: [
                                              Container(
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                              Column(
                                                children: [
                                                  Material(
                                                    elevation: 20.0,
                                                    shadowColor: Colors.white,
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .all(const Radius
                                                            .circular(10.0)),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        errorStyle: TextStyle(
                                                            height: 0),
                                                        prefixIcon: Icon(
                                                            Icons.person,
                                                            color:
                                                                Colors.green),
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .green,
                                                                    width: 2.0),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    const Radius
                                                                            .circular(
                                                                        10.0))),
                                                        enabledBorder: !nameerror
                                                            ? const OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 0.0),
                                                                borderRadius: BorderRadius.all(
                                                                    const Radius
                                                                            .circular(
                                                                        10.0)))
                                                            : const OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .red,
                                                                        width:
                                                                            1.0),
                                                                borderRadius: BorderRadius.all(
                                                                    const Radius
                                                                            .circular(
                                                                        10.0))),
                                                        border:
                                                            new OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(10.0),
                                                          ),
                                                        ),
                                                        hintText: 'Name',
                                                      ),
                                                      maxLines: null,
                                                      controller: _name,
                                                      validator: (val) {
                                                        if (val.isEmpty) {
                                                          setState(() {
                                                            nameerror = true;
                                                          });
                                                          return '';
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  errornamemessage(),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15.0),
                                          Stack(children: [
                                            Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )),
                                            Column(
                                              children: [
                                                Material(
                                                  elevation: 20.0,
                                                  shadowColor: Colors.white,
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          const Radius.circular(
                                                              10.0)),
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                      errorStyle:
                                                          TextStyle(height: 0),
                                                      prefixIcon: Icon(
                                                          Icons.email,
                                                          color: Colors.green),
                                                      focusedBorder: const OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .green,
                                                                  width: 2.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  const Radius
                                                                          .circular(
                                                                      10.0))),
                                                      enabledBorder: !emailerror
                                                          ? const OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          0.0),
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      const Radius
                                                                              .circular(
                                                                          10.0)))
                                                          : const OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .red,
                                                                      width:
                                                                          1.0),
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      const Radius
                                                                              .circular(
                                                                          10.0))),
                                                      border:
                                                          new OutlineInputBorder(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          const Radius.circular(
                                                              10.0),
                                                        ),
                                                      ),
                                                      hintText: 'Email',
                                                    ),
                                                    maxLines: null,
                                                    controller: _email,
                                                    validator: (val) {
                                                      if (val.isEmpty) {
                                                        setState(() {
                                                          emailerror = true;
                                                        });
                                                        return '';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                erroremailmessage(),
                                              ],
                                            ),
                                          ]),
                                          SizedBox(height: 15.0),
                                          Stack(
                                            children: [
                                              Container(
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                              Column(
                                                children: [
                                                  Material(
                                                    elevation: 20.0,
                                                    shadowColor: Colors.white,
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .all(const Radius
                                                            .circular(10.0)),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                              focusedErrorBorder: const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .red,
                                                                      width: 2),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          const Radius.circular(
                                                                              10.0))),
                                                              errorStyle:
                                                                  TextStyle(
                                                                      height:
                                                                          0),
                                                              prefixIcon: Icon(
                                                                Icons
                                                                    .create_rounded,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              hintText:
                                                                  'Password',
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          2.0),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          const Radius.circular(
                                                                              10.0))),
                                                              enabledBorder:
                                                                  !passerror
                                                                      ? const OutlineInputBorder(
                                                                          borderSide:
                                                                              const BorderSide(color: Colors.white, width: 0.0),
                                                                          borderRadius: BorderRadius.all(const Radius.circular(10.0)))
                                                                      : const OutlineInputBorder(
                                                                          borderSide: const BorderSide(
                                                                              color: Colors.red,
                                                                              width: 1.0),
                                                                          borderRadius:
                                                                              BorderRadius.all(const Radius.circular(10.0)),
                                                                        ),
                                                              border: new OutlineInputBorder(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  const Radius
                                                                          .circular(
                                                                      10.0),
                                                                ),
                                                              ),
                                                              suffixIcon: IconButton(
                                                                icon: Icon(
                                                                  _obscureText1
                                                                      ? Icons
                                                                          .visibility
                                                                      : Icons
                                                                          .visibility_off,
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _obscureText1 =
                                                                        !_obscureText1;
                                                                  });
                                                                },
                                                              )),
                                                      controller: _password,
                                                      validator: (val) {
                                                        if (val.length < 7) {
                                                          setState(() {
                                                            passerror = true;
                                                          });
                                                          print(passerror);
                                                          return '';
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      obscureText:
                                                          _obscureText1,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  errorpassmessage(),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15.0),
                                          Stack(
                                            children: [
                                              Container(
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                              Column(
                                                children: [
                                                  Material(
                                                    elevation: 20.0,
                                                    shadowColor: Colors.white,
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .all(const Radius
                                                            .circular(10.0)),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                              focusedErrorBorder: const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .red,
                                                                      width: 2),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          const Radius.circular(
                                                                              10.0))),
                                                              errorStyle:
                                                                  TextStyle(
                                                                      height:
                                                                          0),
                                                              prefixIcon: Icon(
                                                                Icons
                                                                    .create_rounded,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              hintText:
                                                                  'Password',
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          2.0),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          const Radius.circular(
                                                                              10.0))),
                                                              enabledBorder:
                                                                  !passerror
                                                                      ? const OutlineInputBorder(
                                                                          borderSide:
                                                                              const BorderSide(color: Colors.white, width: 0.0),
                                                                          borderRadius: BorderRadius.all(const Radius.circular(10.0)))
                                                                      : const OutlineInputBorder(
                                                                          borderSide: const BorderSide(
                                                                              color: Colors.red,
                                                                              width: 1.0),
                                                                          borderRadius:
                                                                              BorderRadius.all(const Radius.circular(10.0)),
                                                                        ),
                                                              border: new OutlineInputBorder(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  const Radius
                                                                          .circular(
                                                                      10.0),
                                                                ),
                                                              ),
                                                              suffixIcon: IconButton(
                                                                icon: Icon(
                                                                  _obscureText2
                                                                      ? Icons
                                                                          .visibility
                                                                      : Icons
                                                                          .visibility_off,
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
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
                                                          setState(() {
                                                            confirmpassemptyerror =
                                                                true;
                                                          });

                                                          return '';
                                                        } else if (val.length <
                                                            7) {
                                                          setState(() {
                                                            confirmpasslesserro =
                                                                true;
                                                          });
                                                          return '';
                                                        } else if (val !=
                                                            _password.text) {
                                                          setState(() {
                                                            confirmpassnomatcherror =
                                                                true;
                                                          });
                                                          return '';
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      obscureText:
                                                          _obscureText2,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  errorconfirmpassmessage(),
                                                ],
                                              ),
                                            ],
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

  Widget erroremailmessage() {
    if (emailerror) {
      return Container(
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Text(
          'Please enter your email',
          style: TextStyle(fontSize: 12, color: Colors.red[800]),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget errorpassmessage() {
    if (passerror) {
      return Container(
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Text(
          'Enter a password 8+ characters long',
          style: TextStyle(fontSize: 12, color: Colors.red[800]),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget errornamemessage() {
    if (nameerror) {
      return Container(
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Text(
          'Please enter your name',
          style: TextStyle(fontSize: 12, color: Colors.red[800]),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget errorconfirmpassmessage() {
    if (confirmpassemptyerror) {
      return Container(
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Text(
          'Please Re-Enter New Password',
          style: TextStyle(fontSize: 12, color: Colors.red[800]),
        ),
      );
    } else if (confirmpasslesserro) {
      return Container(
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Text(
          'Password must be atleast 8 characters long',
          style: TextStyle(fontSize: 12, color: Colors.red[800]),
        ),
      );
    } else if (confirmpassnomatcherror) {
      return Container(
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Text(
          'Password must be same as above',
          style: TextStyle(fontSize: 12, color: Colors.red[800]),
        ),
      );
    } else {
      return Container();
    }
  }
}
