import 'package:app_client/screens/ViewComplaints/complaint_list.dart';
import "package:flutter/material.dart";

class ViewComplaintScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ComplaintList(),
      ),
    );
  }
}
