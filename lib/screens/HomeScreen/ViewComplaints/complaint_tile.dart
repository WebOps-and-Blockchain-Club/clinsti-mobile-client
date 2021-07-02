import 'dart:convert';
import 'package:app_client/screens/HomeScreen/ShowComplaint/showComplaint.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
      return "Location";
    } catch (e) {
      return loc;
    }
  }
  final Map<String,IconData> statusIcon = {
    "Pending transmission":MdiIcons.clockTimeTwelveOutline,
    "Work is pending":MdiIcons.clockTimeThreeOutline,
    "Work in progress":MdiIcons.progressWrench,
    "Work completed":MdiIcons.checkboxMarkedCircleOutline,
    "Closed with due justification":MdiIcons.lockCheckOutline,
  };
  final Map<String,Color> statusColor = {
    "Pending transmission":Color(0xffd12d5e),
    "Work is pending":Color(0xfff5ae5e),
    "Work in progress":Color(0xfff88d13),
    "Work completed":Color(0xff74c23d),
    "Closed with due justification":Color.fromRGBO(29, 159, 163,1.0),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
            elevation: 20.0,
            shadowColor: Colors.white,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Container(
                width: 40,
                child: Icon(
                  statusIcon[complaint["status"]],
                  color: statusColor[complaint["status"]],
                  size: 40,
                  ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  _getLocation(complaint["_location"]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  ),
              ),
              subtitle:
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(complaint != null ? dateTimeString(complaint["created_time"]) : "Unknown"),
                  ),
        )
            )
    );
  }
}
