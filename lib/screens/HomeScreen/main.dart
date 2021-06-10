import 'dart:io';
import 'package:app_client/screens/HomeScreen/Feedback/main.dart';
import 'package:app_client/screens/HomeScreen/ViewComplaints/main.dart';
import 'package:app_client/screens/HomeScreen/NewComplaint/main.dart';
import 'package:app_client/screens/HomeScreen/Profile/profile.dart';
import 'package:app_client/services/auth.dart';
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
        leading: Icon(Icons.help_outline),
        title: Text("CLinsti"),
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
      endDrawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
            child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(_auth == null
                    ? "USER"
                    : (_auth.useR == null
                        ? "USER"
                        : _auth.useR.name ?? "USER"))),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              try {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyProfileScreen(auth: _auth)));
              } catch (e) {
                print(e.toString());
              }
            },
          ),
          ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()));
              }),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              }),
        ],
      )),
    );
  }
}
