import 'package:app_client/screens/AuthScreen/main.dart';
import 'package:app_client/screens/HomeScreen/main.dart';
import 'package:app_client/screens/VerifyScreen/main.dart';
import 'package:app_client/services/auth.dart';
import 'package:app_client/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String? email;

  setEmail(mail) {
    setState(() {
      email = mail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthService(),
        child: Consumer<AuthService>(builder: (context, auth, child) {
          return auth.tokeN == null
              ? Authenticate(
                  setEmail: setEmail,
                )
              : (auth.verifieD == 'true'
                  ? ChangeNotifierProvider(
                      create: (_) => DatabaseService(), child: HomeScreen())
                  : Verify(
                      email: email ?? "",
                    ));
        }));
  }
}
