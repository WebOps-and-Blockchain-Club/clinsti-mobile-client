import 'package:app_client/models/user.dart';
import 'package:app_client/screens/HomeScreen/Profile/changepassword.dart';
import 'package:app_client/screens/HomeScreen/Feedback/main.dart';
import 'package:app_client/services/auth.dart';
import 'package:app_client/widgets/formErrorMessage.dart';
import 'package:flutter/material.dart';
import 'package:app_client/screens/HomeScreen/Profile/aboutus.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String error;
  bool loading = false;
  bool isEditable = false;
  final GlobalKey<FormState> _formKeyEditName = GlobalKey<FormState>();

  _updateUserProfile({AuthService auth, String name}) async {
    Navigator.pop(context);
    setState(() {
      error = null;
      loading = true;
    });
    try {
      await auth.updateProfile(name: name);
      getUser();
      Fluttertoast.showToast(
          msg: "Profile Updated",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0);
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      final snackBar = SnackBar(
        content: Text(
          error,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      );
      error != null
          ? ScaffoldMessenger.of(context).showSnackBar(snackBar)
          : SizedBox();
    }
    setState(() {
      loading = false;
    });
  }

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

  Future<void> showEditNameDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          TextEditingController _name = TextEditingController();
          String nameerror;
          return StatefulBuilder(builder: (context, setState) {
            _name.text = name;
            return AlertDialog(
              scrollable: true,
              content: Form(
                  key: _formKeyEditName,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Material(
                          elevation: 20.0,
                          shadowColor: Colors.white,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            decoration: InputDecoration(
                                errorStyle: TextStyle(height: 0),
                                hintText: "Name",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.green,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.0),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                            readOnly: false,
                            controller: _name,
                            maxLines: null,
                            validator: (val) {
                              if (val.isEmpty) {
                                setState(() {
                                  nameerror = "Please Enter Name";
                                });
                                return '';
                              } else {
                                setState(() {
                                  nameerror = null;
                                });
                                return null;
                              }
                            },
                          ),
                        ),
                        errorMessages(nameerror),
                        SizedBox(height: 10),
                        Center(
                          child: ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  elevation: MaterialStateProperty.all(10)),
                              onPressed: () async {
                                if (_formKeyEditName.currentState.validate())
                                  await _updateUserProfile(
                                    auth: widget.auth,
                                    name: _name.text,
                                  );
                              },
                              icon: Icon(MdiIcons.circleEditOutline),
                              label: Text(
                                "Update Profile",
                                textScaleFactor: 1.2,
                              )),
                        ),
                      ],
                    ),
                  )),
              // actions: <Widget>[
              //   TextButton(
              //     child: Text('Cancel'),
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //   ),
              //   ElevatedButton.icon(
              //       style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all(Colors.green),
              //           elevation: MaterialStateProperty.all(4)),
              //       onPressed: () async {
              //         if (_formKeyEditName.currentState.validate())
              //           await _updateUserProfile(
              //             auth: widget.auth,
              //             name: _name.text,
              //           );
              //       },
              //       icon: Icon(MdiIcons.circleEditOutline),
              //       label: Text(
              //         "Update Profile",
              //         textScaleFactor: 1.2,
              //       ))
              // ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (email != null && name != null)
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
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
                                fontSize: 25, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Text(
                            email,
                            style: TextStyle(color: Colors.grey[800]),
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
                              'Change Profile Name',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18),
                            ),
                            onPressed: () async {
                              await showEditNameDialog(context);
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
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                alignment: Alignment.center),
                            label: Text(
                              'Change Password',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPasswordScreen(
                                          auth: widget.auth)));
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
                                      builder: (context) => FeedbackWrapper()));
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
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutUsScreen()));
                            },
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
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green[400])),
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
    else if (loading)
      return CircularProgressIndicator();
    else
      return Scaffold(
        body: Center(
          child: Text(
            "Some error occured!",
            style: TextStyle(
                color: Colors.red, fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
      );
  }
}
