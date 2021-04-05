import 'package:app_client/screens/HomeScreen/Feedback/main.dart';
import 'package:app_client/screens/HomeScreen/ViewComplaints/main.dart';
import 'package:app_client/screens/HomeScreen/NewComplaint/main.dart';
import 'package:app_client/screens/HomeScreen/Profile/profile.dart';
import 'package:app_client/services/auth.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  final AuthService auth;
  HomeScreen({this.auth});
  static const routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  void _onItemTap(int i) {
    setState(() {
      index = i;
    });
  }

  void _logout() async {
    widget.auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    widget.auth.verifyToken().then((value) {
      if (!value) {
        Fluttertoast.showToast(
            msg: 'Login expired',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 14.0);
      }
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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyProfileScreen()));
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
              })
        ],
      ),
      body: Center(
        child: (index == 0) ? NewComplaintScreen() : ViewComplaintScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_outlined), label: "New Complaint"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: "My Complaints")
        ],
        currentIndex: index,
        onTap: _onItemTap,
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}
