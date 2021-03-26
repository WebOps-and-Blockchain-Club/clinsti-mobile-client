import 'package:app_client/models/complaint.dart';
import 'package:flutter/material.dart';

class ComplaintTile extends StatelessWidget {
  final Complaint complaint;
  ComplaintTile({this.complaint});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
            child: ListTile(
          leading:
              Icon(complaint.status == "completed" ? Icons.done : Icons.sync),
          tileColor: complaint.status != "completed"
              ? Colors.orangeAccent
              : Colors.greenAccent,
          title: Text(complaint.location),
          subtitle: Text(complaint.timestamp),
        )));
  }
}
