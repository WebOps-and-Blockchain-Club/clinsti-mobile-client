import 'dart:convert';

import 'package:app_client/screens/HomeScreen/ShowComplaint/complaintImages.dart';
import 'package:app_client/screens/Map/main.dart';
import 'package:app_client/services/database.dart';
import 'package:flutter/material.dart';
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
  List<bool> status = [false, false, false, false];

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

    }
    setState(() {
      loading = false;
    });
  }

  _setIconStatus(String currentStatus){
    if(currentStatus == "Closed with due justification"){
      return;
    }
    if(currentStatus == "Pending transmission"){
      status[0] = true;
    }
    else if(currentStatus == "Work is pending"){
      status[0] = true;
      status[1] = true;
    }
    else if(currentStatus == "Work in progress"){
      status[0] = true;
      status[1] = true;
      status[2] = true;
    }
    else if(currentStatus == "Work completed"){
      status[0] = true;
      status[1] = true;
      status[2] = true;
      status[3] = true;
    }
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
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          children: [
            Icon(Icons.location_on),
            SizedBox(width: 10,),
            Flexible(child: Text(
                loc,
                style: TextStyle(fontSize: 17),
              )),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Request ID: ${widget.complaint["complaint_id"]}'),
      ),
      body: loading? Center(child: CircularProgressIndicator(),)
      :
      ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          _buildRequestDetail(complaint['description']),
          SizedBox(height: 20,),
          _getLocationWidget(widget.complaint['_location']),
          SizedBox(height: 20,),
          _buildRequestDate(complaint["created_time"]),
          SizedBox(height: 20,),
          if(complaint['status'] != "Closed with due justification")
          _buildProgressIndicator(status, width),
          Center(
            child: Text(
              complaint["status"] ?? "",
              style: TextStyle(
                fontSize: 20,
                color: (complaint["status"] == 'completed')
                    ? Colors.green
                    : Colors.redAccent,
              ),
            ),
          ),
          SizedBox(height: 20,),
          if(complaint["admin_remark"] != null)
          _buildRequestDetail(complaint["admin_remark"]),
          if(complaint["admin_remark"] != null)
          SizedBox(height: 20,),
          if(complaint["images"] != null)
            TextButton(
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
              child: Text("Images")
            ),
          SizedBox(
            height: 20,
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
            SizedBox(height: 20),
          if (complaint["status"] != null && (complaint["status"] == "Work completed" ||
              complaint["status"] == "Closed with due justification"))
            // (complaint['feedback_remark'] == null &&
                //     complaint['status'] !=
                //         "Closed with due justification")
                // ? 
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
                        hintText: complaint['status'] ==
                                "Closed with due justification"
                            ? 'Justification'
                            : 'Feedback',
                      ),
                    ),
                  ),
                // : Text(complaint['status'] ==
                //         "Closed with due justification"
                //     ? (complaint['admin_remark'] ??
                //         'Unnecessary Complaint')
                //     : complaint['feedback_remark']),
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
                    print(complaint['feedback_remark']);
                    print(complaint['feedback_rating']);
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
              complaint["status"] == "Pending transmission")
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
    );
  }

  _buildProgressIndicator(List<bool> status, double width){
    //_setIconStatus(complaint['status'].toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProgressIcon(status[0], iconData: MdiIcons.clipboardClockOutline),
            _buildProgressLine(status[1], 25),
            _buildProgressIcon(status[1], iconData: MdiIcons.clockTimeThreeOutline,),
            _buildProgressLine(status[2], 25),
            _buildProgressIcon(status[2], iconData: Icons.hourglass_bottom),
            _buildProgressLine(status[3], 25),
            _buildProgressIcon(status[3], iconData: Icons.check_circle_outline),
          ],
        ),
        Column(
          children: [
            Text('Registered on'),
            Text('Completed on')
          ],
        )
      ],
    );
  }

  _buildProgressIcon(bool isDone, {IconData iconData = Icons.check_circle}){
    return IconButton(
      icon: Icon(
        iconData,
        color: isDone ? Colors.green[400] : Colors.grey,
      ),
      onPressed: null,
    );
  }

  _buildProgressLine(bool isDone, double height){
    return SizedBox(
      height: height,
      child: VerticalDivider(
        thickness: 2.5,
        color: isDone ? Colors.green[400] : Colors.grey,
      ),
    );
  }

  _buildRequestDetail(String requestDetail){
    return 
    Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5)
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.label),
          SizedBox(width: 10,),
          Flexible(
            child: Text(
              requestDetail ?? "Description",
              style: TextStyle(
                fontSize: 17
              ),
              softWrap: 
              true,
            ),
          ),
        ],
      ),
    );
  }
}

_buildRequestDate(String requestDate){
  return Container(
    padding: EdgeInsets.all(10),
    child: RichText(
      softWrap: true,
      text: TextSpan(
        text: 'Registered On: ',
        style: TextStyle(
          fontSize: 16, 
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: dateTimeString(requestDate),
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue[600],
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    ),
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(5)
    ),
  );
}

String dateTimeString( String utcDateTime) {
  var parseDateTime = DateTime.parse(utcDateTime);
  final localDateTime = parseDateTime.toLocal();

  var dateTimeFormat = DateFormat("dd/MM/yyyy hh:mm:ss aaa");

  return dateTimeFormat.format(localDateTime);
}
