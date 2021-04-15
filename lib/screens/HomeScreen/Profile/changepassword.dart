import 'package:flutter/material.dart';

class EditPasswordScreen extends StatefulWidget {
  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  String error;
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
                    //controller: _password,
                    // 'Update validator'
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
                    child: Text(
                      'Update Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      // Update at server
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
