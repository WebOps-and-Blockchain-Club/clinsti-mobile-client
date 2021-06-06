import 'dart:convert';

import 'package:app_client/screens/Map/main.dart';
import 'package:app_client/services/database.dart';
import 'package:flutter/material.dart';

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
  Map<String,dynamic> complaint = {};
  bool loading = false;

  @override
  initState(){
    super.initState();
    setState(() {
      complaint["location"] = widget.complaint["_location"];
      complaint["complaint_id"] = widget.complaint["complaint_id"];
    });
    _fetchComplaint();
  }

  _fetchComplaint()async{
    setState(() {
      loading = true;
    });
    try{
      dynamic result = await widget.db
          .getComplaint(widget.complaint["complaint_id"]);
      setState(() {
        complaint = result;
        // complaint["description"] = result["description"] ?? "";
        // complaint["status"] = result["status"] ?? "";
        // complaint["created_time"] = result["created_time"] ?? "";
        // complaint["feedback_rating"] = result["feedback_rating"];
        // complaint["feedback_remark"] = result["feedback_remark"];
        // complaint["admin_remark"] = result["admin_remark"];
        // complaint["waste_type"] = result["waste_type"] ?? "";
        // complaint["zone"] = result["zone"] ?? "";
        // complaint["completed_time"] = result["completed_time"];
        // complaint["images"] = result["images"] ?? [];
      });
    } catch(e) {

    }
    setState(() {
      loading = false;
    });
  }

  Widget _getLocationWidget(String loc) {
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
              )
            )
          );
        },
        child: Row(
          children: [
            Icon(Icons.location_on),
            Text("geoLocation",style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline)),
          ],
        ),
      );
    } catch (e) {
      return Row(
        children: [
          Text(loc),
          Spacer(),
          Icon(Icons.location_on),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Request ID: ${widget.complaint["complaint_id"]}'),
      ),
      body: loading? Center(child: CircularProgressIndicator(),):Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            _getLocationWidget(widget.complaint['_location']),
            SizedBox(
              height: 30,
            ),
            Text(complaint['description']??""),
            SizedBox(
              height: 20,
            ),
            Text(
              'Registered on: ${complaint["created_time"] ?? ""}',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Status: ${complaint["status"] ?? ""}',
              style: TextStyle(
                fontSize: 20,
                color: (complaint["status"] == 'completed')
                    ? Colors.green
                    : Colors.redAccent,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            if (complaint["status"] != null && (complaint["status"]== 'Work completed' ||
                complaint["status"] == 'Closed with due justification'))
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
                                    : (complaint["feedback_rating"] ??
                                        0)))
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                        color: (index <
                                (complaint == null
                                    ? 0
                                    : (complaint["feedback_rating"] ??
                                        0)))
                            ? Colors.yellowAccent
                            : Colors.grey,
                        onPressed: () {
                          if ((complaint != null &&
                                  complaint["feedback_rating"] ==
                                      null) ||
                              complaint["feedback_remark"] == null ||
                              showSubmitButton) {
                            setState(() {
                              complaint["feedback_rating"] = index + 1;
                              showSubmitButton = true;
                            });
                          }
                        }
                      );
                    },
                  ),
                ),
              ),
            if (complaint["status"] != null && (complaint["status"] == "Work completed" ||
                complaint["status"] == "Closed with due justification"))
              (complaint['feedback_remark'] == null &&
                      complaint['status'] !=
                          "Closed with due justification")
                  ? Form(
                      key: _formKey,
                      child: TextFormField(
                        maxLines: null,
                        controller: feedback,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        enabled: (complaint != null &&
                            complaint["feedback_remark"] == null),
                        decoration: InputDecoration(
                          hintText: complaint['status'] ==
                                  "Closed with due justification"
                              ? 'Justification'
                              : 'Feedback',
                        ),
                      ),
                    )
                  : Text(complaint['status'] ==
                          "Closed with due justification"
                      ? (complaint['admin_remark'] ??
                          'Unnecessary Complaint')
                      : complaint['feedback_remark']),
            SizedBox(
              height: 20,
            ),
            if (showSubmitButton)
              Center(
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child:
                        Text('Submit Feedback', style: TextStyle(fontSize: 18)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        showSubmitButton = false;
                        complaint["feedback_remark"] = feedback.text;
                      });
                      await widget.db.postRequestFeedback(
                          widget.complaint['complaint_id'],
                          complaint['feedback_rating'],
                          complaint['feedback_remark']);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Feedback Submitted')));
                    }
                  },
                ),
              ),
            if (complaint != null &&
                complaint["status"] != 'Work completed' &&
                complaint['status'] != "Closed with due justification")
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'Resolve Complaint',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await widget.db
                        .deleteRequest(widget.complaint['complaint_id']);
                    Navigator.pop(context);
                  },
                ),
              ]),
          ],
        ),
      ),
    );
  }
}
