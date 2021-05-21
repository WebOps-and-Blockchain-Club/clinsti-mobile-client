import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Link extends StatefulWidget {
  @override
  _LinkState createState() => _LinkState();
}

class _LinkState extends State<Link> {
  SharedPreferences _prefs;
  String link;
  final TextEditingController _link = TextEditingController();
  @override
  void initState() {
    super.initState();
    link = "";
    init();
  }

  init() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _link.text = _prefs.getString('link') ?? null;
  }

  save() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setString('link', _link.text);
    link = _prefs.getString('link');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _link,
          ),
          IconButton(
              icon: Icon(Icons.adb),
              onPressed: (() {
                save();
              })),
          Text(link),
        ],
      ),
    );
  }
}
