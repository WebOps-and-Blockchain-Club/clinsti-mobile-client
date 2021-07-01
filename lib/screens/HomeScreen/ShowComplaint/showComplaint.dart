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
  Map<String,dynamic> complaint = {};
  bool loading = false;
  String error;  
  List<Color> statusColors = []..length = 7;
  List<bool> lineBools = [false, false, false];

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
      });
      _setIconStatus(complaint['status'].toString());
      feedback.text = complaint['feedback_remark'] ?? "";
    } catch(e) {
      setState(() {
        error = e.toString();
      });
    }
    setState(() {
      loading = false;
    });
  }

  _setIconStatus(String currentStatus){
    if(currentStatus == "Pending transmission"){
      statusColors[0] = Colors.green;
      statusColors[1] = Colors.purple;
      for(int i = 2; i < 7; i++){
        statusColors[i] = Colors.grey;
      }
      lineBools[0] = true;
    }
    else if(currentStatus == "Work is pending"){
      for(int i = 0; i < 3; i++){
        statusColors[i] = Colors.green[400];
      }
      statusColors[3] = Colors.purple;
      for(int i = 4; i < 7; i++){
        statusColors[i] = Colors.grey;
      }
      lineBools[1] = true;
    }
    else if(currentStatus == "Work in progress"){
      for(int i = 0; i < 5; i++){
        statusColors[i] = Colors.green[400];
      }
      statusColors[5] = Colors.purple;
      statusColors[6] = Colors.grey;
      lineBools[2] = true;
    }
    else if(currentStatus == "Work completed"){
      for(int i = 0; i < 7; i ++){
        statusColors[i] = Colors.green;
      }
    }
    else if(currentStatus == "Closed with due justification"){
      statusColors[0] = Colors.green;
      statusColors[1] = Colors.green;
      statusColors[2] = Colors.green;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if(error != null) 
      return Center(
        child: Text("Oops! Something went wrong!"),
      );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          complaint["status"] ?? "",
          style: TextStyle(
            fontSize: 20,
            color: (complaint["status"] == 'Work completed')
                ? Colors.green[400]
                : Colors.redAccent,
          ),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: loading? Center(child: CircularProgressIndicator(),)
      :
      SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            _buildRequestDetail(complaint['description']),
            SizedBox(height: 20,),
            _getLocationWidget(widget.complaint['_location'], context),
            SizedBox(height: 20,),
            // if(complaint['status'] != "Closed with due justification")
            _buildProgressIndicator(statusColors, width),
            // if(complaint['status'] != "Closed with due justification")
            SizedBox(height: 20,),
            if(complaint["admin_remark"] != null)
            Text(
              "Administration Remark",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            if(complaint["admin_remark"] != null)
            _buildRequestDetail(complaint["admin_remark"]),
            if(complaint["admin_remark"] != null)
            SizedBox(height: 20,),
            if (complaint["status"]== 'Work completed' ||
                complaint["status"] == 'Closed with due justification')
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
            if (complaint["status"]== 'Work completed' ||
                complaint["status"] == 'Closed with due justification')
              SizedBox(height: 20),
            if (complaint["status"] == "Work completed" ||
                complaint["status"] == "Closed with due justification" && complaint["feedback_remark"] != null)
              Text(
              "Feedback",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            if (complaint["status"] == "Work completed" ||
                complaint["status"] == "Closed with due justification")
                  Form(
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
                          border: OutlineInputBorder(),
                          hintText: 'Rate & Give Feedback',
                        ),
                      ),
                    ),
            if (complaint["status"] == "Work completed" ||
                complaint["status"] == "Closed with due justification")
              SizedBox(
                height: 20,
              ),
            if (showSubmitButton)
              Center(
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                      'Submit Feedback', 
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                  ),
                  onTap: () async {
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
            if (complaint["status"] == "Pending transmission")
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                  onTap: () async {
                    await widget.db
                        .deleteRequest(widget.complaint['complaint_id']);
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "Request Removed",
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 14.0);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                      'Resolve Complaint',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ]),
          ],
        ),
      ),
      
      floatingActionButton: (complaint['images'] != null) ? FloatingActionButton(
        child: Icon(Icons.photo_library),
        onPressed: () async{
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
      ) : null,
    );
  }

  _buildProgressIndicator(List<Color> iconColors, double width){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildProgressIcon(statusColors[0], iconData: MdiIcons.clipboardClockOutline,),
                _buildProgressText(Colors.black, complaint['created_time'], "Pending Transmission", false , width)
              ],
            ),
            _buildProgressLine(statusColors[1]),
            if(complaint['status'] != "Closed with due justification")
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildProgressIcon(statusColors[2], iconData: MdiIcons.clockTimeThreeOutline,),
                _buildProgressText(Colors.black, complaint['registered_time'] ?? "", "Work is pending", lineBools[0], width)
            ],),
            if(complaint['status'] != "Closed with due justification")
            _buildProgressLine(statusColors[3]),
            if(complaint['status'] != "Closed with due justification")
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildProgressIcon(statusColors[4], iconData: Icons.hourglass_bottom),
                _buildProgressText(Colors.black, complaint['work_started_time'] ?? "", "Work in progress", lineBools[1], width)              
            ],),
            if(complaint['status'] != "Closed with due justification")
            _buildProgressLine(statusColors[5]),
            if(complaint['status'] != "Closed with due justification")
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildProgressIcon(iconColors[6], iconData: Icons.check_circle_outline),
                _buildProgressText(Colors.black, complaint['completed_time'] ?? "", "Work completed", lineBools[2], width),
              ],
            ),
            if(complaint['status'] == "Closed with due justification")
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildProgressIcon(Colors.red, iconData: Icons.close),
                _buildProgressText(Colors.black, complaint['completed_time'] ?? "", "Closed with due Justification", false, width),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _buildProgressIcon(Color color, {IconData iconData}){
    return SizedBox(
      width: 60,
      height: 80, 
      child: IconButton(
        icon: Icon(
          iconData,
          color: color,
          size: 40,
        ),
        onPressed: null,
      ),
    );
  }

  _buildProgressText(Color color, String date, String status, bool current, double width){
    return SizedBox(
      width: width - 100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RichText(
            text: TextSpan(
              text: dateTimeString(date),
              style: TextStyle(color: Colors.black),
              children: [
                if(date != "")
                TextSpan(
                  text: "\n",
                ),
                TextSpan(
                  text: status,
                  style: TextStyle(color: current ? Colors.purple : Colors.grey)
                )
              ]
            ), 
          )
        ),
      ),
    );
  }

  _buildProgressLine(Color color){
    return SizedBox(
      height: 30,
      width: 60,
      child: Center(
        child: VerticalDivider(
          thickness: 2.5,
          color: color,
        ),
      ),
    );
  }

  _buildRequestDetail(String requestDetail){
    return 
    Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green[400],
        ),
        borderRadius: BorderRadius.circular(5),
        
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            Icons.label,
            color: Colors.green[400],
          ),
          SizedBox(width: 10,),
          Flexible(
            child: Text(
              requestDetail ?? "Description",
              style: TextStyle(
                fontSize: 17
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
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
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green[400],
          ),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.green[400],
            ),
            SizedBox(width: 10,),
            // Flexible(child: Text(
                // loc,
                // style: TextStyle(fontSize: 17),
            //   )),
            Expanded(child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                loc,
                style: TextStyle(fontSize: 17),
              ),
            ),)
          ],
        ),
      );
    }
  }


String dateTimeString( String utcDateTime) {
  if(utcDateTime == ""){
    return "";
  }
  var parseDateTime = DateTime.parse(utcDateTime);
  final localDateTime = parseDateTime.toLocal();

  var dateTimeFormat = DateFormat("dd/MM/yyyy hh:mm:ss aaa");

  return dateTimeFormat.format(localDateTime);
}
