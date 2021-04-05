import 'package:app_client/screens/HomeScreen/Profile/changepassword.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
                    'Update Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    // Update at server
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
          ))),
    );
  }
}
