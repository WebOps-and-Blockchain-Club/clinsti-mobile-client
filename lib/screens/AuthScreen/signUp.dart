import 'package:app_client/services/auth.dart';
import 'package:app_client/widgets/formErrorMessage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  final Function setEmail;
  SignUp(this.toggleView, this.setEmail);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  String? error;
  bool loading = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  String? nameerror;
  String? emailerror;
  String? passerror;
  String? confirmpasserror;
  final _formKey = GlobalKey<FormState>();
  _signUp(AuthService auth) async {
    setState(() {
      error = null;
      loading = true;
    });
    try {
      await auth.signUp(_email.text.trim(), _password.text, _name.text);
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      if (error != null) {
        final snackBar = SnackBar(
          content: Text(
            error!,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
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
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.56,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image:
                                            Svg('assets/clinsti_logo-01.svg'),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                height: 30,
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
                                                        enabledBorder: const OutlineInputBorder(
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
                                                        if (val != null &&
                                                            val.isEmpty) {
                                                          setState(() {
                                                            nameerror =
                                                                'Please enter your name';
                                                          });
                                                          return '';
                                                        } else {
                                                          setState(() {
                                                            nameerror = null;
                                                          });
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  errorMessages(nameerror),
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
                                                      enabledBorder: const OutlineInputBorder(
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
                                                      if (val != null &&
                                                          val.isEmpty) {
                                                        setState(() {
                                                          emailerror =
                                                              'Please enter your email';
                                                        });
                                                        return '';
                                                      } else if (val != null &&
                                                          !EmailValidator
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
                                                errorMessages(emailerror)
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
                                                        if (val != null &&
                                                            val.length < 7) {
                                                          setState(() {
                                                            passerror =
                                                                'Password must be atleast 8 characters long';
                                                          });
                                                          return '';
                                                        } else {
                                                          setState(() {
                                                            passerror = null;
                                                          });
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
                                                  errorMessages(passerror),
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
                                                                  'Confirm Password',
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
                                                        if (val != null &&
                                                            val.isEmpty) {
                                                          setState(() {
                                                            confirmpasserror =
                                                                'Please Re-Enter New Password';
                                                          });
                                                          return '';
                                                        } else if (val !=
                                                                null &&
                                                            val.length < 7) {
                                                          setState(() {
                                                            confirmpasserror =
                                                                'Password must be 8 characters long';
                                                          });
                                                          return '';
                                                        } else if (val !=
                                                            _password.text) {
                                                          setState(() {
                                                            confirmpasserror =
                                                                'Password must be same as above';
                                                          });
                                                          return '';
                                                        } else {
                                                          setState(() {
                                                            confirmpasserror =
                                                                null;
                                                          });
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
                                                  errorMessages(
                                                      confirmpasserror),
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
                                                if (_formKey.currentState !=
                                                        null &&
                                                    _formKey.currentState!
                                                        .validate()) {
                                                  await _signUp(auth);
                                                  widget.setEmail(_email.text);
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
                                                  "Already have an Account ? "),
                                              GestureDetector(
                                                onTap: () =>
                                                    widget.toggleView(),
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
      ),
    );
  }
}
