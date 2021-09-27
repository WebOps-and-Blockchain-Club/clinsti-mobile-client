import 'dart:ui';
import 'package:app_client/services/auth.dart';
import 'package:app_client/widgets/formErrorMessage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_client/screens/AuthScreen/forgotpassword.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _obscureText = true;
  String emailerror;
  String passerror;

  final _formKey = GlobalKey<FormState>();
  _signIn(AuthService auth) async {
    setState(() {
      error = null;
      loading = true;
    });
    try {
      await auth.signIn(_email.text.trim(), _password.text);
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      final snackBar = SnackBar(
        content: Text(
          error,
          textAlign: TextAlign.center
          ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                      child: CircularProgressIndicator(color: Colors.green),
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
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: Svg(
                                                'assets/clinsti_logo-01.svg'),
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    'Welcome Back! ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Login To Continue',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
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
                                              Stack(children: [
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
                                                              Icons.email,
                                                              color:
                                                                  Colors.green),
                                                          focusedBorder: const OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          2.0),
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      const Radius
                                                                              .circular(
                                                                          10.0))),
                                                          enabledBorder: const OutlineInputBorder(
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
                                                                          10.0))),
                                                          border:
                                                              new OutlineInputBorder(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              const Radius
                                                                      .circular(
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
                                                              emailerror =
                                                                  'Please Enter your Email';
                                                            });
                                                            return '';
                                                          } else if (!EmailValidator
                                                              .validate(
                                                                  val.trim())) {
                                                            setState(() {
                                                              emailerror =
                                                                  'Please enter valid email';
                                                            });
                                                            return '';
                                                          } else {
                                                            setState(() {
                                                              emailerror = null;
                                                            });
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    errorMessages(emailerror),
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
                                                            BorderRadius
                                                                .circular(10),
                                                      )),
                                                  Column(
                                                    children: [
                                                      Material(
                                                        elevation: 20.0,
                                                        shadowColor:
                                                            Colors.white,
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                const Radius
                                                                        .circular(
                                                                    10.0)),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  errorStyle:
                                                                      TextStyle(
                                                                          height:
                                                                              0),
                                                                  prefixIcon:
                                                                      Icon(
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
                                                                      borderRadius: BorderRadius.all(
                                                                          const Radius.circular(
                                                                              10.0))),
                                                                  enabledBorder: const OutlineInputBorder(
                                                                      borderSide: const BorderSide(
                                                                          color: Colors
                                                                              .white,
                                                                          width:
                                                                              0.0),
                                                                      borderRadius:
                                                                          BorderRadius.all(const Radius.circular(
                                                                              10.0))),
                                                                  border:
                                                                      new OutlineInputBorder(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      const Radius
                                                                              .circular(
                                                                          10.0),
                                                                    ),
                                                                  ),
                                                                  suffixIcon:
                                                                      IconButton(
                                                                    icon: Icon(
                                                                      _obscureText
                                                                          ? Icons
                                                                              .visibility
                                                                          : Icons
                                                                              .visibility_off,
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        _obscureText =
                                                                            !_obscureText;
                                                                      });
                                                                    },
                                                                  )),
                                                          controller: _password,
                                                          validator: (val) {
                                                            if (val.isEmpty) {
                                                              setState(() {
                                                                passerror =
                                                                    'Enter your Password';
                                                              });
                                                              return '';
                                                            } else {
                                                              setState(() {
                                                                passerror =
                                                                    null;
                                                              });
                                                              return null;
                                                            }
                                                          },
                                                          obscureText:
                                                              _obscureText,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      errorMessages(passerror),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      try {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ForgotPassword(
                                                                          auth:
                                                                              auth,
                                                                        )));
                                                      } catch (e) {
                                                        print(e.toString());
                                                      }
                                                    },
                                                    child: Text(
                                                      'Forgot Password?',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15.0),
                                              Center(
                                                child: ElevatedButton.icon(
                                                  icon: ImageIcon(
                                                    AssetImage(
                                                        "assets/sign-in.png"),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.green),
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(10),
                                                  ),
                                                  label: Text(
                                                    'Login',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () async {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      await _signIn(auth);
                                                    }
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 6.0),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "Don't have an Account ? "),
                                                  GestureDetector(
                                                    onTap: widget.toggleView,
                                                    child: Text(
                                                      "Sign Up",
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
                            ),
                          ),
                        ),
                      ],
                    ),
              bottomNavigationBar: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                child: GestureDetector(
                  onTap: () {
                    launch(
                      'http://cfi.iitm.ac.in',
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Developed with ❤️ by  ',
                      ),
                      Image(
                        image: AssetImage('assets/CFI_Logo.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
