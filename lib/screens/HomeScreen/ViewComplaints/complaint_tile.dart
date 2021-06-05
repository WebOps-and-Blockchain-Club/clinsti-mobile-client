import 'dart:convert';
import 'package:flutter/material.dart';

class ComplaintTile extends StatelessWidget {
  final dynamic complaint;
  ComplaintTile({this.complaint});
  String _getLocation(String loc) {
    if(loc == null){
      return "Unknown";
    }
    try {
      var obj = jsonDecode(loc);
      // ignore: unnecessary_statements
      obj['Latitude'];
      return "geoLocation";
    } catch (e) {
      return loc;
    }
  }
  final Map<String,IconData> statusIcon = {
    "Pending transmission":Icons.pending_actions_rounded,
    "Work is pending":Icons.access_time,
    "Work in progress":Icons.sync,
    "Work completed":Icons.download_done_outlined,
    "Closed with due justification":Icons.sync_disabled_rounded,
  };
  final Map<String,Color> statusColor = {
    "Pending transmission":Colors.grey[200],
    "Work is pending":Colors.orange[300],
    "Work in progress":Color.fromRGBO(194, 194, 0, 1),
    "Work completed":Colors.greenAccent,
    "Closed with due justification":Colors.red[200],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
            child: ListTile(
          leading: Icon(statusIcon[complaint["status"]]),
          tileColor: statusColor[complaint["status"]],
          title: Text(_getLocation(complaint["_location"])),
          subtitle:
              Text(complaint != null ? complaint["created_time"] : "Unknown"),
        )
      )
    );
  }
}
