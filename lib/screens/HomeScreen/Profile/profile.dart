import 'package:app_client/models/user.dart';
import 'package:app_client/screens/HomeScreen/Profile/changepassword.dart';
import 'package:app_client/services/auth.dart';
import 'package:app_client/services/server.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  final User user;
  final AuthService auth;
  MyProfileScreen({this.user, this.auth});
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  String error;
  bool isEditable = false;
  FocusNode nameFocusNode;
  Server http = new Server();

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    super.dispose();
  }

  _updateUserProfile({AuthService auth, String email, String name}) async {
    try {
      setState(() {
        error = null;
      });
      User user = await auth.getUpdatedProfile(email: email, name: name);
      setState(() {
        _name.text = user.name;
        _email.text = user.email;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _name.text = widget.user.name;
    _email.text = widget.user.email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Form(
                child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      // Users can enter into this field and change details directly
                      hintText: 'Users current name displayed ',
                      border: OutlineInputBorder(),
                    ),
                    focusNode: nameFocusNode,
                    readOnly: !isEditable,
                    controller: _name,
                    maxLines: null,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter valid details' : null,
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'Users current email displayed',
                      //helperText: 'Enter your email',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    controller: _email,
                    readOnly: !isEditable,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter valid email' : null,
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text(
                      !isEditable ? 'Edit Profile' : 'Update Profile',
                      style: TextStyle(color: Colors.white),
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
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      'Change Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPasswordScreen()));
                    },
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
            )),
          )),
    );
  }
}
