import 'package:app_client/services/auth.dart';
import 'package:app_client/widgets/formErrorMessage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditPasswordScreen extends StatefulWidget {
  final AuthService auth;
  EditPasswordScreen({this.auth});

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String error;
  String passError;
  String newPassError;
  String confirmPassError;

  bool loading = false;
  bool _obscureText1 = false;
  bool _obscureText2 = false;
  bool _obscureText3 = false;

  _updateUserPassword(
      {AuthService auth, String oldPassword, String newPassword}) async {
    setState(() {
      loading = true;
    });
    try {
      await auth.changePassword(oldPassword, newPassword);
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
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: SingleChildScrollView(
                          child: Form(
                              key: _formKey,
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/user-01.png",
                                      scale: 1,
                                      color: Colors.green,
                                    ),
                                    SizedBox(height: 20),
                                    Material(
                                      elevation: 20.0,
                                      shadowColor: Colors.white,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(height: 0),
                                          hintText: "Password",
                                          prefixIcon: Icon(
                                            MdiIcons.pencilOffOutline,
                                            color: Colors.green,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 0.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText1
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText1 = !_obscureText1;
                                              });
                                            },
                                          ),
                                        ),
                                        readOnly: false,
                                        controller: oldPassword,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            setState(() {
                                              passError =
                                                  "Please enter your current password";
                                            });
                                            return '';
                                          } else {
                                            setState(() {
                                              passError = null;
                                            });
                                            return null;
                                          }
                                        },
                                        obscureText: _obscureText1,
                                      ),
                                    ),
                                    errorMessages(passError),
                                    SizedBox(height: 20),
                                    Material(
                                      elevation: 20.0,
                                      shadowColor: Colors.white,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(height: 0),
                                          hintText: "New Password",
                                          prefixIcon: Icon(
                                            MdiIcons.pencilOutline,
                                            color: Colors.green,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 0.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText2
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText2 = !_obscureText2;
                                              });
                                            },
                                          ),
                                        ),
                                        readOnly: false,
                                        controller: newPassword,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            setState(() {
                                              newPassError =
                                                  "Please enter your new password";
                                            });
                                            return '';
                                          } else {
                                            setState(() {
                                              newPassError = null;
                                            });
                                            return null;
                                          }
                                        },
                                        obscureText: _obscureText2,
                                      ),
                                    ),
                                    errorMessages(newPassError),
                                    SizedBox(height: 20),
                                    Material(
                                      elevation: 20.0,
                                      shadowColor: Colors.white,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(height: 0),
                                          hintText: "Confirm New Password",
                                          prefixIcon: Icon(
                                            MdiIcons.pencilOutline,
                                            color: Colors.green,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 0.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  new Radius.circular(10.0))),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText3
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText3 = !_obscureText3;
                                              });
                                            },
                                          ),
                                        ),
                                        controller: confirmPassword,
                                        readOnly: false,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            setState(() {
                                              confirmPassError =
                                                  "Please enter your Confirm Password";
                                            });
                                            return '';
                                          } else if (val != newPassword.text) {
                                            setState(() {
                                              confirmPassError =
                                                  "Password must be same as above";
                                            });
                                            return '';
                                          } else {
                                            setState(() {
                                              confirmPassError = null;
                                            });
                                            return null;
                                          }
                                        },
                                        obscureText: _obscureText3,
                                      ),
                                    ),
                                    errorMessages(confirmPassError),
                                    SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green),
                                              elevation:
                                                  MaterialStateProperty.all(
                                                      10)),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate())
                                              await _updateUserPassword(
                                                  auth: widget.auth,
                                                  oldPassword: oldPassword.text,
                                                  newPassword:
                                                      newPassword.text);
                                          },
                                          icon: Icon(MdiIcons.lockCheckOutline),
                                          label: Text(
                                            "Update Password",
                                            textScaleFactor: 1.2,
                                          )),
                                    ),
                                    SizedBox(height: 20.0),
                                    error != null
                                        ? Text(
                                            error,
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : SizedBox()
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
