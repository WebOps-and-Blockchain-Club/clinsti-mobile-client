import 'package:flutter/material.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/rendering.dart';
import 'package:app_client/widgets/formErrorMessage.dart';
import 'package:timer_button/timer_button.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  bool otpsent = false;
  bool otpsubmit = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  String emailerror;
  String passerror;
  String confirmpasserror;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: otpsubmit
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 120,
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
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(10.0))),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    prefixIcon:
                                        Icon(Icons.email, color: Colors.green),
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
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.green, width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(10.0))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 0.0),
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(10.0))),
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
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
                                            _obscureText1 = !_obscureText1;
                                          });
                                        },
                                      )),
                                  controller: _password,
                                  validator: (val) {
                                    if (val.length < 7) {
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
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.green, width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(10.0))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 0.0),
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(10.0))),
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
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
                                            _obscureText2 = !_obscureText2;
                                          });
                                        },
                                      )),
                                  controller: _confirmpass,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      setState(() {
                                        confirmpasserror =
                                            'Please Re-Enter New Password';
                                      });

                                      return '';
                                    } else if (val.length < 7) {
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
                                        MaterialStateProperty.all(Colors.green),
                                    elevation: MaterialStateProperty.all(10),
                                  ),
                                  child: Text('Submit'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    prefixIcon:
                                        Icon(Icons.email, color: Colors.green),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.green, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(10.0))),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(10.0))),
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    hintText: 'Email',
                                  ),
                                  maxLines: null,
                                  controller: _email,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      setState(() {
                                        emailerror = 'Please Enter your Email';
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
                                              const Radius.circular(10.0)),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(height: 0),
                                              prefixIcon: ImageIcon(
                                                AssetImage('assets/otp.png'),
                                                color: Colors.green,
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.green,
                                                              width: 2.0),
                                                      borderRadius: BorderRadius
                                                          .all(const Radius
                                                              .circular(10.0))),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.white,
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
                                              hintText: 'OTP',
                                            ),
                                            maxLines: null,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: TimerButton(
                                            label: "Resend OTP",
                                            timeOutInSeconds: 15,
                                            color: Colors.green,
                                            onPressed: () {},
                                          ),
                                        ),
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
                                            child: Text('Submit OTP'),
                                            onPressed: () {
                                              setState(() {
                                                otpsubmit = true;
                                              });
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
                                              MaterialStateProperty.all(10),
                                        ),
                                        child: Text(
                                          'Send OTP',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            otpsent = true;
                                          });
                                        },
                                      ),
                                    ),
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
