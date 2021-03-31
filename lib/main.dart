import 'package:app_client/screens/wrapper.dart';
import "package:flutter/material.dart";

// Import packages

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "IITM Complaints",
      // home: HomeScreen(),
      // routes: {
      //   HomeScreen.routeName: (_) => HomeScreen(),
      // },
      home: Wrapper(),
    );
  }
}
