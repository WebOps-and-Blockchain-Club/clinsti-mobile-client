import 'dart:convert';

import 'package:app_client/screens/HomeScreen/ShowComplaint/complaintImages.dart';
import 'package:app_client/screens/Map/main.dart';
import 'package:app_client/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ShowComplaint extends StatefulWidget {
  final dynamic complaint;
  final DatabaseService db;
  ShowComplaint({this.complaint, this.db});

  @override
  _ShowComplaintState createState() => _ShowComplaintState();
}

class _ShowComplaintState extends State<ShowComplaint> {
  bool showSubmitButton = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController feedback = TextEditingController();
  Map<String, dynamic> complaint = {};
  bool loading = false;
  String error;
  String feedbackRequestError;
  List<Color> statusColors = []..length = 7;
  List<bool> lineBools = [false, false, false, false];

  @override
  initState() {
    super.initState();
    setState(() {
      complaint["location"] = widget.complaint["_location"];
      complaint["complaint_id"] = widget.complaint["complaint_id"];
    });
    _fetchComplaint();
  }

  _fetchComplaint() async {
    setState(() {
      loading = true;
    });
    try {
      dynamic result =
          await widget.db.getComplaint(widget.complaint["complaint_id"]);
      setState(() {
        complaint = result;
      });
      _setIconStatus(complaint['status'].toString());
      feedback.text = complaint['feedback_remark'] ?? "";
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
    setState(() {
      loading = false;
    });
  }

  _deleteComplaint() async {
    await widget.db.deleteRequest(
      widget.complaint['complaint_id']);
    Fluttertoast.showToast(
        msg: "Request Removed",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0);
    Navigator.pop(context);
  }

  _postComplaintFeedback() async {
    setState(() {
      loading = true;
      complaint["feedback_remark"] = feedback.text;
    });
    try {
      await widget.db.postRequestFeedback(widget.complaint["complaint_id"],
          complaint['feedback_rating'], complaint['feedback_remark']);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Feedback Submitted')));
    } catch (e) {
      setState(() {
        feedbackRequestError = e.toString();
        showSubmitButton = true;
        loading = false;
      });
    }
    setState(() {
      showSubmitButton = false;
      loading = false;
    });
  }

  _setIconStatus(String currentStatus) {
    if (currentStatus == "Pending transmission") {
      statusColors[0] = Colors.green[300];
      for (int i = 1; i < 7; i++) {
        statusColors[i] = Colors.grey;
      }
      lineBools[0] = true;
    } else if (currentStatus == "Work is pending") {
      for (int i = 0; i < 3; i++) {
        statusColors[i] = Colors.green[300];
      }
      for (int i = 3; i < 7; i++) {
        statusColors[i] = Colors.grey;
      }
      lineBools[1] = true;
    } else if (currentStatus == "Work in progress") {
      for (int i = 0; i < 5; i++) {
        statusColors[i] = Colors.green[300];
      }
      statusColors[5] = Colors.grey;
      statusColors[6] = Colors.grey;
      lineBools[2] = true;
    } else if (currentStatus == "Work completed") {
      for (int i = 0; i < 7; i++) {
        statusColors[i] = Colors.green[300];
      }
      lineBools[3] = true;
    } else if (currentStatus == "Closed with due justification") {
      statusColors[0] = Colors.green[300];
      statusColors[1] = Colors.green[300];
      statusColors[2] = Colors.green[300];
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (error != null)
      return Center(
        child: Text("Oops! Something went wrong!"),
      );
    if (complaint == null)
      return Center(
        child: Text("No data found"),
      );
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          BackButton(),
                          Text(
                            complaint["status"] ?? "",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.green[400],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildRequestDetail(
                        complaint['description'], "Description"),
                    SizedBox(
                      height: 20,
                    ),
                    _getLocationWidget(widget.complaint['_location'], context),
                    SizedBox(
                      height: 20,
                    ),
                    _buildProgressIndicator(statusColors, width),
                    SizedBox(
                      height: 20,
                    ),
                    if (complaint["admin_remark"] != null)
                      _buildRequestDetail(
                          complaint["admin_remark"], "Administration Remark"),
                    if (complaint["admin_remark"] != null)
                      SizedBox(
                        height: 20,
                      ),
                    if (complaint["status"] == "Pending transmission")
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                    elevation: MaterialStateProperty.all(10)),
                                    onPressed: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: Icon(
                                                Icons.warning,
                                                color: Colors.red,
                                                ),
                                              content: const Text(
                                                'Are you sure to resolve complaint?',
                                                style: TextStyle(
                                                  fontSize: 18
                                                ),
                                                ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, 'Cancel');
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(Colors.green),),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _deleteComplaint();
                                                  },
                                                  child: const Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(Colors.green),),
                                                ),
                                              ]
                                      ),
                                    ),
                                child: Text(
                                  'Resolve Complaint',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ]),
                    if (complaint["status"] == 'Work completed' ||
                        complaint["status"] == 'Closed with due justification')
                      _feedbackWidget(),
                  ],
                ),
              ),
            ),
      floatingActionButton: (complaint['images'] != null)
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              child: Icon(Icons.photo_library),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ComplaintImages(
                              imgNames: complaint["images"],
                              db: widget.db,
                            )));
                await widget.db.synC();
                setState(() {});
              },
            )
          : null,
    );
  }

  _buildProgressIndicator(List<Color> iconColors, double width) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: kElevationToShadow[3],
        color: Theme.of(context).bottomAppBarColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Progress",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildProgressIcon(
                    statusColors[0],
                    iconData: MdiIcons.clockTimeTwelveOutline,
                  ),
                  _buildProgressText(Colors.black, complaint['created_time'],
                      "Pending Transmission", lineBools[0], width)
                ],
              ),
              _buildProgressLine(statusColors[1]),
              if (complaint['status'] != "Closed with due justification")
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildProgressIcon(
                      statusColors[2],
                      iconData: MdiIcons.clockTimeThreeOutline,
                    ),
                    _buildProgressText(
                        Colors.black,
                        complaint['registered_time'] ?? "",
                        "Work is pending",
                        lineBools[1],
                        width)
                  ],
                ),
              if (complaint['status'] != "Closed with due justification")
                _buildProgressLine(statusColors[3]),
              if (complaint['status'] != "Closed with due justification")
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildProgressIcon(statusColors[4],
                        iconData: MdiIcons.progressWrench),
                    _buildProgressText(
                        Colors.black,
                        complaint['work_started_time'] ?? "",
                        "Work in progress",
                        lineBools[2],
                        width)
                  ],
                ),
              if (complaint['status'] != "Closed with due justification")
                _buildProgressLine(statusColors[5]),
              if (complaint['status'] != "Closed with due justification")
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildProgressIcon(iconColors[6],
                        iconData: MdiIcons.checkboxMarkedCircleOutline),
                    _buildProgressText(
                        Colors.black,
                        complaint['completed_time'] ?? "",
                        "Work completed",
                        lineBools[3],
                        width),
                  ],
                ),
              if (complaint['status'] == "Closed with due justification")
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildProgressIcon(Colors.green[300],
                        iconData: MdiIcons.lockCheckOutline),
                    _buildProgressText(
                        Colors.black,
                        complaint['completed_time'] ?? "",
                        "Closed with due Justification",
                        true,
                        width),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  _buildProgressIcon(Color color, {IconData iconData}) {
    return SizedBox(
      width: 60,
      height: 40,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(
          iconData,
          color: color,
          size: 35,
        ),
        onPressed: null,
      ),
    );
  }

  _buildProgressText(
      Color color, String date, String status, bool current, double width) {
    return SizedBox(
      width: width - 100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: RichText(
              text: TextSpan(
                  text: dateTimeString(date),
                  style:
                      TextStyle(color: current ? Colors.green : Colors.black),
                  children: [
                    if (date != "")
                      TextSpan(
                        text: "\n",
                      ),
                    TextSpan(
                        text: status,
                        style: TextStyle(
                            color: current ? Colors.green : Colors.grey,
                            fontWeight:
                                current ? FontWeight.bold : FontWeight.normal,
                            fontSize: current ? 18 : 14))
                  ]),
            )),
      ),
    );
  }

  _buildProgressLine(Color color) {
    return SizedBox(
      height: 20,
      width: 60,
      child: Center(
        child: VerticalDivider(
          thickness: 2.5,
          color: color,
        ),
      ),
    );
  }

  _buildRequestDetail(String description, String heading) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: kElevationToShadow[3],
        color: Theme.of(context).bottomAppBarColor,
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading != null)
            Text(
              heading,
              style: TextStyle(color: Colors.grey),
            ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  description ?? "Description",
                  style: TextStyle(fontSize: 17),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getLocationWidget(String loc, BuildContext context) {
    try {
      var obj = jsonDecode(loc);
      // ignore: unnecessary_statements
      obj['Latitude'];
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapSelect(
                        loc: loc,
                        select: false,
                      )));
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: kElevationToShadow[3],
            color: Theme.of(context).bottomAppBarColor,
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.location_on),
              Text("Location",
                  style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline)),
            ],
          ),
        ),
      );
    } catch (e) {
      return _buildRequestDetail(loc, "Location");
    }
  }

  Widget _feedbackWidget() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: kElevationToShadow[3],
        color: Theme.of(context).bottomAppBarColor,
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //if(heading != null)
          (complaint["feedback_rating"] == null)
              ? Text(
                  "Give your feedback",
                  style: TextStyle(color: Colors.grey),
                )
              : Text(
                  "Your feedback",
                  style: TextStyle(color: Colors.grey),
                ),
          Center(
            child: Container(
              width: 0.67 * width,
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, int index) {
                  return IconButton(
                      icon: (index <
                              (complaint == null
                                  ? 0
                                  : (complaint["feedback_rating"] ?? 0)))
                          ? Icon(Icons.star)
                          : Icon(Icons.star_border),
                      color: (index <
                              (complaint == null
                                  ? 0
                                  : (complaint["feedback_rating"] ?? 0)))
                          ? Colors.green
                          : Colors.grey,
                      onPressed: () {
                        if ((complaint != null &&
                                complaint["feedback_rating"] == null) ||
                            complaint["feedback_remark"] == null ||
                            showSubmitButton) {
                          setState(() {
                            complaint["feedback_rating"] = index + 1;
                            showSubmitButton = true;
                          });
                        }
                      });
                },
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              maxLines: 3,
              controller: feedback,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else if (value.length <= 5) {
                  return "Please enter few more words";
                }
                return null;
              },
              enabled:
                  (complaint != null && complaint["feedback_remark"] == null),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your feedback here',
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.green, width: 2.0),
                    borderRadius:
                        BorderRadius.all(const Radius.circular(10.0))),
              ),
            ),
          ),
          if (showSubmitButton)
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    elevation: MaterialStateProperty.all(5)),
                child: Text(
                  'Submit Feedback',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _postComplaintFeedback();
                  }
                },
              ),
            ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

String dateTimeString(String utcDateTime) {
  if (utcDateTime == "") {
    return "";
  }
  var parseDateTime = DateTime.parse(utcDateTime);
  final localDateTime = parseDateTime.toLocal();

  var dateTimeFormat = DateFormat("dd/MM/yyyy hh:mm:ss aaa");

  return dateTimeFormat.format(localDateTime);
}
