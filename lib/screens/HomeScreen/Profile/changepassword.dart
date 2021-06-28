import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditPasswordScreen extends StatefulWidget {

  final AuthService auth;
  EditPasswordScreen({this.auth});

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String error;
  bool loading = false;
  bool _obscureText1 = false;
  bool _obscureText2 = false;
  bool _obscureText3 = false;

  _updateUserPassword({AuthService auth, String oldPassword, String newPassword}) async {
    setState(() {
      loading=true;
    });
    try{
      await auth.changePassword(oldPassword, newPassword);
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Password Updated",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0
      );
    }catch(e){}
      setState(() {
        loading=false;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Edit Profile'),
      // ),
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
                                hintText: "Password",
                                prefixIcon: Icon(
                                  MdiIcons.pencilOffOutline ,
                                  color: Colors.green,
                                  ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.white,width: 0.0),
                                  ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText1? Icons.visibility : Icons.visibility_off,
                                    color: Colors.green,
                                    ),
                                  onPressed: () {setState(() {
                                    _obscureText1 = !_obscureText1;
                                  });},
                                ),
                              ),
                              readOnly: false,
                              controller: oldPassword,
                              validator: (val) => val.isEmpty ? "Please enter your Password" : null,
                              obscureText: _obscureText1,
                            ),
                          ),
                          SizedBox(height: 20),
                          Material(
                            elevation: 20.0,
                            shadowColor: Colors.white,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "New Password",
                                prefixIcon: Icon(
                                  MdiIcons.pencilOutline,
                                  color: Colors.green,
                                  ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.white,width: 0.0),
                                  ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText2? Icons.visibility : Icons.visibility_off,
                                    color: Colors.green,
                                    ),
                                  onPressed: () {setState(() {
                                    _obscureText2 = !_obscureText2;
                                  });},
                                ),
                              ),
                              readOnly: false,
                              controller: newPassword,
                              validator: (val) => val.isEmpty ? "Please enter your New Password" : null,
                              obscureText: _obscureText2,
                            ),
                          ),
                          SizedBox(height: 20),
                          Material(
                            elevation: 20.0,
                            shadowColor: Colors.white,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Confirm New Password",
                                prefixIcon: Icon(
                                  MdiIcons.pencilOutline,
                                  color: Colors.green,
                                  ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.white,width: 0.0),
                                  ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(new Radius.circular(10.0))
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText3? Icons.visibility : Icons.visibility_off,
                                    color: Colors.green,
                                    ),
                                  onPressed: () {setState(() {
                                    _obscureText3 = !_obscureText3;
                                  });},
                                ),
                              ),
                              readOnly: false,
                              validator: (val) {
                                if(val.isEmpty) return "Please enter your Confirm Password";
                                if(val != newPassword.text) return "Password must be same as above";
                                return null;
                                },
                              obscureText: _obscureText3,
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all( Colors.green),
                                elevation: MaterialStateProperty.all( 10 )
                              ),
                              onPressed: () async {
                                if(_formKey.currentState.validate())
                                  await _updateUserPassword(
                                    auth: widget.auth,
                                    oldPassword: oldPassword.text,
                                    newPassword: newPassword.text);
                              },
                              icon: Icon(MdiIcons.lockCheckOutline),
                              label: Text("Update Password")),
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
