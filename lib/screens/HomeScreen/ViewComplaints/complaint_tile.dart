import 'dart:convert';
import 'package:flutter/material.dart';

class ComplaintTile extends StatelessWidget {
  final dynamic complaint;
  ComplaintTile({this.complaint});
  String _getLocation(String loc) {
    try {
      var obj = jsonDecode(loc);
      obj['Latitude'];
      return "geoLocation";
    } catch (e) {
      return loc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
            child: ListTile(
          leading: Icon(complaint["status"] == "Work completed"
              ? Icons.done
              : (complaint["status"] == "Closed with due justification"
                  ? Icons.warning
                  : Icons.sync)),
          tileColor: complaint["status"] != "Work completed"
              ? (complaint["status"] == "Closed with due justification"
                  ? Colors.blue[400]
                  : Colors.orange[300])
              : Colors.greenAccent,
          title: Text(complaint != null
              ? _getLocation(complaint["_location"])
              : "unknown"),
          subtitle:
              Text(complaint != null ? complaint["created_time"] : "unknown"),
        )));
  }
}
