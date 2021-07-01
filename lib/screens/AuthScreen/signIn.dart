import 'package:app_client/services/auth.dart';
import 'package:app_client/widgets/formErrorMessage.dart';
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
                                          padding: EdgeInsets.symmetric(
                                              vertical: 40),
                                          color: Colors.white,
                                        )),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 80,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image:
                                                  AssetImage('assets/82.png'),
                                              fit: BoxFit.cover)),
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
                                                                    height: 0),
                                                            prefixIcon: Icon(
                                                                Icons.email,
                                                                color: Colors
                                                                    .green),
                                                            focusedBorder: const OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .green,
                                                                    width: 2.0),
                                                                borderRadius: BorderRadius.all(
                                                                    const Radius
                                                                            .circular(
                                                                        10.0))),
                                                            enabledBorder: const OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 0.0),
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
                                                            } else {
                                                              setState(() {
                                                                emailerror =
                                                                    null;
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
                                                        decoration:
                                                            BoxDecoration(
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
                                                                    focusedErrorBorder: const OutlineInputBorder(
                                                                        borderSide: const BorderSide(
                                                                            color: Colors
                                                                                .red,
                                                                            width:
                                                                                2),
                                                                        borderRadius: BorderRadius.all(const Radius.circular(
                                                                            10.0))),
                                                                    errorStyle: TextStyle(
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
                                                                        borderRadius: BorderRadius.all(const Radius.circular(
                                                                            10.0))),
                                                                    enabledBorder: const OutlineInputBorder(
                                                                        borderSide: const BorderSide(
                                                                            color: Colors.white,
                                                                            width: 0.0),
                                                                        borderRadius: BorderRadius.all(const Radius.circular(10.0))),
                                                                    border: new OutlineInputBorder(
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .all(
                                                                        const Radius.circular(
                                                                            10.0),
                                                                      ),
                                                                    ),
                                                                    suffixIcon: IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        _obscureText
                                                                            ? Icons.visibility
                                                                            : Icons.visibility_off,
                                                                        color: Colors
                                                                            .grey[600],
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
                                                            controller:
                                                                _password,
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
                                                        errorMessages(
                                                            passerror),
                                                      ],
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
                                                              .all(
                                                                  Colors.green),
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
                                                        "Don't have an Account ? "),
                                                    GestureDetector(
                                                      onTap: widget.toggleView,
                                                      child: Text(
                                                        "Sign Up",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
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
            ));
  }
}
