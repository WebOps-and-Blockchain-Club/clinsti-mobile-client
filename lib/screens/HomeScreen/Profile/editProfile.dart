import 'package:app_client/models/user.dart';
import 'package:app_client/services/auth.dart';
import 'package:app_client/widgets/formErrorMessage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyEditProfileScreen extends StatefulWidget {
  final AuthService auth;
  MyEditProfileScreen({required this.auth});
  @override
  _MyEditProfileScreenState createState() => _MyEditProfileScreenState();
}

class _MyEditProfileScreenState extends State<MyEditProfileScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? error;
  bool loading = false;
  String? nameerror;
  String? emailerror;

  FocusNode? nameFocusNode;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    getUser();
    loading = false;
  }

  @override
  void dispose() {
    nameFocusNode?.dispose();
    super.dispose();
  }

  getUser() {
    User? user = widget.auth.useR;
    _name.text = user?.name ?? "";
    _email.text = user?.email ?? "";
  }

  _updateUserProfile(
      {required AuthService auth,
      required String email,
      required String name}) async {
    setState(() {
      error = null;
      loading = true;
    });
    try {
      await auth.updateProfile(name: name);
      Navigator.pop(context);
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
      if (error != null) {
        final snackBar = SnackBar(
          content: Text(
            error!,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        );
        error != null
            ? ScaffoldMessenger.of(context).showSnackBar(snackBar)
            : SizedBox();
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: SingleChildScrollView(
                          child: Form(
                              key: _formKey,
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/user-01.png",
                                      scale: 1,
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
                                            errorStyle: TextStyle(height: 0),
                                            hintText: "Name",
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.green,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 0.0),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)))),
                                        readOnly: false,
                                        controller: _name,
                                        maxLines: null,
                                        validator: (val) {
                                          if (val != null && val.isEmpty) {
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
                                    SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green),
                                              elevation:
                                                  MaterialStateProperty.all(
                                                      10)),
                                          onPressed: () async {
                                            if (_formKey.currentState != null &&
                                                _formKey.currentState!
                                                    .validate())
                                              await _updateUserProfile(
                                                  auth: widget.auth,
                                                  name: _name.text,
                                                  email: _email.text);
                                          },
                                          icon:
                                              Icon(MdiIcons.circleEditOutline),
                                          label: Text(
                                            "Update Profile",
                                            textScaleFactor: 1.2,
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    error != null
                                        ? Text(
                                            error!,
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : SizedBox()
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
