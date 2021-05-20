import 'package:flutter/material.dart';

class ComplaintTile extends StatelessWidget {
  final dynamic complaint;
  ComplaintTile({this.complaint});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
            child: ListTile(
          // leading:
          //     Icon(complaint.status == "completed" ? Icons.done : Icons.sync),
          // tileColor: complaint.status != "completed"
          //     ? Colors.orangeAccent
          //     : Colors.greenAccent,
          title: Text(complaint != null ? complaint["_location"] : "unknown"),
          subtitle:
              Text(complaint != null ? complaint["created_time"] : "unknown"),
        )));
  }
}
