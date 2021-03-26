import 'package:app_client/screens/ViewComplaints/main.dart';
import "package:flutter/material.dart";

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list_alt),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewComplaintScreen()));
              })
        ],
      ),
      body: Center(
        child: Text("Hello world"),
      ),
    );
  }
}
