import 'package:app_client/screens/AuthScreen/main.dart';
import 'package:app_client/screens/HomeScreen/main.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthService(),
        child: Consumer<AuthService>(builder: (context, auth, child) {
          return auth.token == null ? Authenticate() : HomeScreen();
        }));
  }
}
