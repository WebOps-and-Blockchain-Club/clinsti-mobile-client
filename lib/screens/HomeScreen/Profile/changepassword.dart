import 'package:app_client/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditPasswordScreen extends StatefulWidget {

  final AuthService auth;
  EditPasswordScreen({this.auth});

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  String error;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Form(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      //icon: Icon(Icons.create_rounded),
                      hintText: 'Current Password',
                      border: OutlineInputBorder(),
                    ),
                    controller: oldPassword,
                    validator: (val) => val.length < 7
                        ? 'Enter a password 8+ chars long'
                        : null,
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      //icon: Icon(Icons.create_rounded),
                      hintText: 'New Password', 
                      border: OutlineInputBorder(),
                    ),
                    controller: newPassword,
                    validator: (val) => val.length < 7
                        ? 'Enter a password 8+ chars long'
                        : null,
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      //icon: Icon(Icons.create_rounded),
                      hintText: 'Comfirm New Password',
                      border: OutlineInputBorder(),
                    ),
                    //controller: _password,
                    validator: (val) => val.length < 7
                        ? 'Enter a password 8+ chars long'
                        : null,
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Colors.green,
                    child: loading? CircularProgressIndicator():Text(
                      'Update Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      setState(() {
                        loading=true;
                      });
                      try{
                      await widget.auth.changePassword(oldPassword.text, newPassword.text);
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                            msg: "Password Updated",
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 14.0
                          );
                      }catch(e){}
                      setState(() {
                        loading=false;
                      });
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
