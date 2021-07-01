import 'package:app_client/models/user.dart';
import 'package:app_client/screens/HomeScreen/Profile/changepassword.dart';
import 'package:app_client/screens/HomeScreen/Feedback/main.dart';
import 'package:app_client/screens/HomeScreen/Profile/editProfile.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyProfileScreen extends StatefulWidget {
  final AuthService auth;
  MyProfileScreen({this.auth});
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String name;
  String email;
  //String error;
  bool loading = false;
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() {
    User user = widget.auth.useR;
    name = user.name;
    email = user.email;
  }

  void _logout() async {
    widget.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: BackButton(),
          ),
          Expanded(
            child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                            Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 40,
                                child: ImageIcon(
                                  AssetImage('assets/user-01.png'),
                                  size: 65,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Center(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                email,
                                style: TextStyle(
                                  color: Colors.grey[800]
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Container(
                              height: 45,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  MdiIcons.accountEditOutline,
                                  color: Colors.black87,
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white)),
                                label: Text(
                                        'Edit Profile',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black87, fontSize: 18),
                                      ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyEditProfileScreen(
                                              auth: widget.auth)));
                                },
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Container(
                              height: 45,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  MdiIcons.accountLockOutline,
                                  color: Colors.black87,
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.white),
                                    alignment: Alignment.center
                                    ),
                                label: Text(
                                  'Change Password',
                                  style:
                                      TextStyle(color: Colors.black87, fontSize: 18),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditPasswordScreen(auth: widget.auth)));
                                },
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Container(
                              height: 45,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  MdiIcons.commentEditOutline,
                                  color: Colors.black87,
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white)),
                                label: Container(
                                  child: Text(
                                    'Feedback',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FeedbackScreen()));
                                },
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Container(
                              height: 45,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  MdiIcons.informationOutline,
                                  color: Colors.black87,
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white)),
                                label: Text('About Us',
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 18)),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 55,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  MdiIcons.logout,
                                  color: Colors.black87,
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green[400])),
                                label: Text('Logout',
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 18)),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  _logout();
                                },
                              ),
                            ),
                            // error != null
                            //     ? Text(
                            //         error,
                            //         style: TextStyle(color: Colors.red),
                            //       )
                            //     : SizedBox()
                  ],
                ),
                    ))),
          ),
        ],
      ),
    );
  }
}
