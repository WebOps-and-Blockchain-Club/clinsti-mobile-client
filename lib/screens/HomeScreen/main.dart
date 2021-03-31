import 'package:app_client/screens/HomeScreen/Feedback/main.dart';
import 'package:app_client/screens/HomeScreen/ViewComplaints/main.dart';
import 'package:app_client/screens/HomeScreen/NewComplaint/main.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen extends StatelessWidget {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(
//     //   appBar: AppBar(
//     //     title: Text("App"),
//     //     actions: <Widget>[
//     //       IconButton(
//     //           icon: Icon(Icons.list_alt),
//     //           onPressed: () {
//     //             Navigator.push(
//     //                 context,
//     //                 MaterialPageRoute(
//     //                     builder: (context) => ViewComplaintScreen()));
//     //           }),
//     //       IconButton(
//     //         icon: Icon(Icons.edit_outlined),
//     //         onPressed: (){
//     //           Navigator.push(context, MaterialPageRoute(builder: (context) => NewComplaintScreen()));
//     //         }
//     //       )
//     //     ],
//     //   ),
//     //   body: Center(
//     //     child: Text("Hello world"),
//     //   ),
//     // );
//
//
//   }
// }

class HomeScreen extends StatefulWidget {
  final Function changeUser;
  HomeScreen({this.changeUser});
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    widget.changeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("App Name"),
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
