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
  bool _obscureText = true;
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
                                                Material(
                                                    elevation: 20.0,
                                                    shadowColor: Colors.white,
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .all(const Radius
                                                            .circular(10.0)),
                                                    child: Stack(children: [
                                                      TextFormField(
                                                        decoration:
                                                            InputDecoration(
                                                          prefixIcon: Icon(
                                                              Icons.email,
                                                              color:
                                                                  Colors.green),
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
                                                        validator: (val) => val
                                                                .isEmpty
                                                            ? 'Please enter your email'
                                                            : null,
                                                      ),
                                                    ])),
                                                SizedBox(height: 15.0),
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
                                                        prefixIcon: Icon(
                                                          Icons.create_rounded,
                                                          color: Colors.green,
                                                        ),
                                                        hintText: 'Password',
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
                                                        suffixIcon: IconButton(
                                                          icon: Icon(
                                                            _obscureText
                                                                ? Icons
                                                                    .visibility
                                                                : Icons
                                                                    .visibility_off,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _obscureText =
                                                                  !_obscureText;
                                                            });
                                                          },
                                                        )),
                                                    controller: _password,
                                                    validator: (val) => val
                                                                .length <
                                                            7
                                                        ? 'Password did not match'
                                                        : null,
                                                    obscureText: _obscureText,
                                                  ),
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
