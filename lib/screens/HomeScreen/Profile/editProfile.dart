import 'package:app_client/models/user.dart';
import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyEditProfileScreen extends StatefulWidget {
  final AuthService auth;
  MyEditProfileScreen({this.auth});
  @override
  _MyEditProfileScreenState createState() => _MyEditProfileScreenState();
}

class _MyEditProfileScreenState extends State<MyEditProfileScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String error;
  bool loading=false;
  FocusNode nameFocusNode;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    getUser();
    loading = false;
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    super.dispose();
  }

  getUser(){
    User user = widget.auth.useR;
    _name.text = user.name;
    _email.text = user.email;
  }

  _updateUserProfile({AuthService auth, String email, String name}) async {
    
    setState(() {
      error = null;
      loading=true;
    });
    try {
      await auth.updateProfile(email: email, name: name);
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Profile Updated",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0
      );
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? 
          Center(
            child: CircularProgressIndicator(),
          ) :
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/user-01.png",
                            scale: 0.8,
                            color: Colors.green,
                            ),
                          SizedBox(height: 20),
                          Material(
                            elevation: 20.0,
                            shadowColor: Colors.white,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Name",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.green,
                                  ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.white,width: 0.0),
                                  ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                )
                              ),
                              readOnly: false,
                              controller: _name,
                              maxLines: null,
                              validator: (val) => val.isEmpty ? "Please enter your name" : null,
                            ),
                          ),
                          SizedBox(height: 20),
                          Material(
                            elevation: 20.0,
                            shadowColor: Colors.white,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.green,
                                  ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.white,width: 0.0),
                                  ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                )
                              ),
                              readOnly: false,
                              controller: _email,
                              maxLines: null,
                              validator: (val) => val.isEmpty ? "Please enter your email" : null,
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all( Colors.green),
                                elevation: MaterialStateProperty.all( 10 )
                              ),
                              onPressed: ()async {
                                if(_formKey.currentState.validate())
                                  await _updateUserProfile(
                                    auth: widget.auth,
                                    name: _name.text,
                                    email: _email.text);},
                              icon: Icon(MdiIcons.circleEditOutline),
                              label: Text("Update Profile")),
                          ),
                        ],
                      )
                    ),
                  ),
                ),
              ],
            ),
          )
    );
  }
}
