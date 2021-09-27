import 'dart:io';

import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {

  String error;
  bool loading = false;

  _getUserInfo(AuthService auth) async {
    try {
      await auth.getUserInfo(); //function is not been called in intial state
    } catch (e) {
      if (e is SocketException) {
        Fluttertoast.showToast(
            msg: 'Server Error',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            textColor: Colors.black,
            fontSize: 14.0);
      } else {
        final snackBar = SnackBar(
          content: Text("Email not verified", textAlign: TextAlign.center),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  _resendVerificationMail(AuthService auth) async {
    setState(() {
      error = null;
      loading = true;
    });
    try {
      await auth.resendVerificationMail();
      Fluttertoast.showToast(
          msg: 'Verification Link Sent',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.black,
          fontSize: 14.0);
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      final snackBar = SnackBar(
        content: Text(error, textAlign: TextAlign.center),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
        builder: (context, auth, child) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: BackButton(
                  color: Colors.green,
                  onPressed: () async {
                    await auth.signOut();
                  },
                ),
              ),
              body: Center(
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    children: [
                      Icon(
                        Icons.mail_rounded,
                        size: 150.0,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Verification mail has been sent to your registered email. Please verify your email to continue!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Text(
                        "Have you verified your email ? If yes, ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            elevation: MaterialStateProperty.all(10),
                          ),
                          onPressed: () async {
                            await _getUserInfo(auth);
                          },
                          child: Text(
                            "Click here",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't get verfication email ? ",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _resendVerificationMail(auth);
                            },
                            child: Text(
                              "Click here",
                              style: TextStyle(
                                  color: Colors.green, fontSize: 15.0),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      )
                    ],
                  ),
                ),
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
