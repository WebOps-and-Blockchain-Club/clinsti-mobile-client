import 'package:app_client/models/user.dart';
import 'package:app_client/screens/HomeScreen/Profile/changepassword.dart';
import 'package:app_client/screens/HomeScreen/Feedback/main.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  final AuthService auth;
  MyProfileScreen({this.auth});
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  String error;
  bool loading = false;
  bool isEditable = false;
  FocusNode nameFocusNode;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    getUser();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    super.dispose();
  }

  getUser() {
    User user = widget.auth.useR;
    _name.text = user.name;
    _email.text = user.email;
  }

  void _logout() async {
    widget.auth.signOut();
  }

  _updateUserProfile({AuthService auth, String email, String name}) async {
    setState(() {
      error = null;
      loading = true;
    });
    try {
      await auth.updateProfile(email: email, name: name);
      setState(() {});
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
    setState(() {
      loading = false;
    });
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
                    child: Form(
                        child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 30,
                        child: ImageIcon(
                          AssetImage('assets/user-01.png'),
                          size: 45,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          // Users can enter into this field and change details directly
                          hintText: 'Users current name displayed ',
                          border: InputBorder.none,
                        ),
                        textAlign: TextAlign.center,
                        focusNode: nameFocusNode,
                        readOnly: true,
                        controller: _name,
                        maxLines: null,
                        validator: (val) =>
                            val.isEmpty ? 'Please enter valid details' : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey[800]),
                        decoration: InputDecoration(
                          hintText: 'Users current email displayed',
                          //helperText: 'Enter your email',
                          border: InputBorder.none,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: null,
                        controller: _email,
                        readOnly: true,
                        validator: (val) =>
                            val.isEmpty ? 'Please enter valid email' : null,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Center(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 350, height: 50),
                        child: ElevatedButton.icon(
                          icon: ImageIcon(
                            AssetImage('assets/edit-profile-01.png'),
                            color: Colors.black87,
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          label: loading
                              ? CircularProgressIndicator()
                              : Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 18),
                                ),
                          onPressed: () async {
                            setState(() {
                              isEditable = !isEditable;
                            });
                            // if(isEditable){
                            //   nameFocusNode.requestFocus();
                            //   _name.value = _name.value.copyWith(
                            //     selection: TextSelection(baseOffset: _name.text.length, extentOffset: _name.text.length),
                            //     composing: TextRange.empty,
                            //   );
                            // }
                            if (!isEditable) {
                              await _updateUserProfile(
                                  auth: widget.auth,
                                  name: _name.text,
                                  email: _email.text);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Center(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 350, height: 50),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: Text(
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
                    ),
                    SizedBox(height: 15.0),
                    Center(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 350, height: 50),
                        child: ElevatedButton.icon(
                          icon: ImageIcon(
                            AssetImage('assets/feedback.png'),
                            color: Colors.black87,
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          label: Text(
                            'Feedback',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
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
                    ),
                    SizedBox(height: 15.0),
                    Center(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 350, height: 50),
                        child: ElevatedButton.icon(
                          icon: ImageIcon(
                            AssetImage('assets/log_out.png'),
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
                    ),
                    SizedBox(height: 10.0),
                    error != null
                        ? Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          )
                        : SizedBox()
                  ],
                )))),
          ),
        ],
      ),
    );
  }
}
