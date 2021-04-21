import 'dart:io';

import 'package:app_client/models/user.dart';
import 'package:app_client/screens/HomeScreen/Feedback/main.dart';
import 'package:app_client/screens/HomeScreen/ViewComplaints/main.dart';
import 'package:app_client/screens/HomeScreen/NewComplaint/main.dart';
import 'package:app_client/screens/HomeScreen/Profile/profile.dart';
import 'package:app_client/services/auth.dart';
import 'package:app_client/services/database.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  PageController _pageController;

  AuthService _auth;
  DatabaseService _db = new DatabaseService(); // use this type for db
  // also use with changeNotifier for get complaintS
  void _onItemTap(int i) {
    _pageController.animateToPage(i,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void _logout() async {
    _auth.signOut();
  }

  void _verifyToken() async {
    _auth.verifyToken().then((user) => {}).catchError((e) {
      if (e is SocketException) {
        Fluttertoast.showToast(
            msg: 'Server Error',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.cyan,
            textColor: Colors.black,
            fontSize: 14.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Login expired',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.cyan,
            textColor: Colors.black,
            fontSize: 14.0);
      }
    });
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: _index);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _auth = Provider.of<AuthService>(context, listen: false);
      _verifyToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("App Name"),
        leading: IconButton(
            icon: Icon(Icons.person),
            onPressed: () async {
              try {
                User user = await _auth.getUserInfo();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyProfileScreen(user: user, auth: _auth)));
              } catch (e) {
                print(e.toString());
              }
            }),
        actions: [
          IconButton(
              icon: Icon(Icons.feedback),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()));
              }),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _logout();
              }),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newpage) {
          setState(() {
            _index = newpage;
          });
        },
        children: [NewComplaintScreen(), ViewComplaintScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_outlined), label: "New Complaint"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: "My Complaints")
        ],
        currentIndex: _index,
        onTap: _onItemTap,
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}
