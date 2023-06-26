import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/rendering.dart';
import 'package:app_client/widgets/formErrorMessage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timer_button_fork/timer_button_fork.dart';

class ForgotPassword extends StatefulWidget {
  final AuthService auth;
  ForgotPassword({required this.auth});
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  bool otpsent = false;
  bool otpsubmit = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool loading = false;
  String? error;
  String? emailerror = null;
  String? otperror;
  String? passerror;
  String? confirmpasserror;
  final _formKey = GlobalKey<FormState>();

  _getOTP(AuthService auth) async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await auth.getOTP(_email.text);
      setState(() {
        otpsent = true;
        loading = false;
      });
      Fluttertoast.showToast(
          msg: "OTP Sent!",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0);
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
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
  }

  _resetPassword(AuthService auth) async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await auth.resetPassword(_email.text.trim(), _otp.text, _password.text);
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Password Updated",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: BackButton(),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        child: Form(
                          key: _formKey,
                          child: otpsubmit
                              ? Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Text(
                                      'Change Password ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Material(
                                      elevation: 20.0,
                                      shadowColor: Colors.white,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(10.0)),
                                      child: TextFormField(
                                        enabled: false,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.white,
                                                      width: 0.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          const Radius.circular(
                                                              10.0))),
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(10.0),
                                            ),
                                          ),
                                          prefixIcon: Icon(Icons.email,
                                              color: Colors.green),
                                          hintText: _email.text,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Material(
                                      elevation: 20.0,
                                      shadowColor: Colors.white,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(10.0)),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(height: 0),
                                            prefixIcon: Icon(
                                              Icons.create_rounded,
                                              color: Colors.green,
                                            ),
                                            hintText: 'New Password',
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.green,
                                                            width: 2.0),
                                                    borderRadius: BorderRadius
                                                        .all(const Radius
                                                            .circular(10.0))),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.white,
                                                            width: 0.0),
                                                    borderRadius: BorderRadius
                                                        .all(const Radius
                                                            .circular(10.0))),
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscureText1
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
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
                                        validator: (val) {
                                          if (val != null && val.length < 7) {
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
                                        obscureText: _obscureText1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    errorMessages(passerror),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Material(
                                      elevation: 20.0,
                                      shadowColor: Colors.white,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(10.0)),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(height: 0),
                                            prefixIcon: Icon(
                                              Icons.create_rounded,
                                              color: Colors.green,
                                            ),
                                            hintText: 'Confirm New Password',
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.green,
                                                            width: 2.0),
                                                    borderRadius: BorderRadius
                                                        .all(const Radius
                                                            .circular(10.0))),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.white,
                                                            width: 0.0),
                                                    borderRadius: BorderRadius
                                                        .all(const Radius
                                                            .circular(10.0))),
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscureText2
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
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
                                          if (val != null && val.isEmpty) {
                                            setState(() {
                                              confirmpasserror =
                                                  'Please Re-Enter New Password';
                                            });

                                            return '';
                                          } else if (val != null &&
                                              val.length < 7) {
                                            setState(() {
                                              confirmpasserror =
                                                  'Password must be 8 characters long';
                                            });
                                            return '';
                                          } else if (val != _password.text) {
                                            setState(() {
                                              confirmpasserror =
                                                  'Password must be same as above';
                                            });
                                            return '';
                                          } else {
                                            setState(() {
                                              confirmpasserror = null;
                                            });
                                            return null;
                                          }
                                        },
                                        obscureText: _obscureText2,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    errorMessages(confirmpasserror),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green),
                                          elevation:
                                              MaterialStateProperty.all(10),
                                        ),
                                        child: Text('Submit'),
                                        onPressed: () async {
                                          if (_formKey.currentState != null &&
                                              _formKey.currentState!
                                                  .validate()) {
                                            await _resetPassword(widget.auth);
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 6.0),
                                    error != null
                                        ? Text(
                                            error!,
                                            style: TextStyle(color: Colors.red),
                                            textAlign: TextAlign.center,
                                          )
                                        : SizedBox(),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 120,
                                    ),
                                    Text(
                                      'Forgot Password ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Material(
                                      elevation: 20.0,
                                      shadowColor: Colors.white,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(10.0)),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(height: 0),
                                          prefixIcon: Icon(Icons.email,
                                              color: Colors.green),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.green,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          const Radius.circular(
                                                              10.0))),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.white,
                                                      width: 0.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          const Radius.circular(
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
                                        validator: (val) {
                                          if (val != null && val.isEmpty) {
                                            setState(() {
                                              emailerror =
                                                  'Please Enter your Email';
                                            });
                                            return '';
                                          } else if (val != null &&
                                              !EmailValidator.validate(
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    otpsent
                                        ? Column(
                                            children: [
                                              Material(
                                                elevation: 20.0,
                                                shadowColor: Colors.white,
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    const Radius.circular(
                                                        10.0)),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    errorStyle:
                                                        TextStyle(height: 0),
                                                    prefixIcon: Icon(
                                                      MdiIcons.messageCog,
                                                      color: Colors.green,
                                                    ),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
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
                                                          const BorderRadius
                                                              .all(
                                                        const Radius.circular(
                                                            10.0),
                                                      ),
                                                    ),
                                                    hintText: 'OTP',
                                                  ),
                                                  maxLines: null,
                                                  controller: _otp,
                                                  validator: (val) {
                                                    if (val != null &&
                                                        val.isEmpty) {
                                                      setState(() {
                                                        otperror =
                                                            'Please Enter OTP';
                                                      });
                                                      return '';
                                                    } else {
                                                      setState(() {
                                                        otperror = null;
                                                      });
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              errorMessages(otperror),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TimerButton(
                                                    label: "Resend OTP",
                                                    timeOutInSeconds: 30,
                                                    color: Colors.transparent,
                                                    activeTextStyle: TextStyle(
                                                        color: Colors.green),
                                                    buttonType:
                                                        ButtonType.TextButton,
                                                    onPressed: () async {
                                                      await _getOTP(
                                                          widget.auth);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.green),
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(10),
                                                  ),
                                                  child: Text('Submit OTP'),
                                                  onPressed: () {
                                                    if (_formKey.currentState !=
                                                            null &&
                                                        _formKey.currentState!
                                                            .validate()) {
                                                      setState(() {
                                                        otpsubmit = true;
                                                      });
                                                    }
                                                  },
                                                ),
                                              )
                                            ],
                                          )
                                        : Center(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        10),
                                              ),
                                              child: Text(
                                                'Send OTP',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                if (_formKey.currentState !=
                                                        null &&
                                                    _formKey.currentState!
                                                        .validate()) {
                                                  await _getOTP(widget.auth);
                                                }
                                              },
                                            ),
                                          ),
                                    SizedBox(height: 6.0),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
