import "package:flutter/material.dart";

// Import packages
import "./screens/HomeScreen/main.dart";

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
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
      },
    );
  }
}
