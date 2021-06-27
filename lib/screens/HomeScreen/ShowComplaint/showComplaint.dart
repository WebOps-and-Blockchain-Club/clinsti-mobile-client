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
  List<Color> statusColors = []..length = 7;

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
      statusColors[0] = Colors.purple;
      for(int i = 1; i < 7; i++){
        statusColors[i] = Colors.grey;
      }
    }
    else if(currentStatus == "Work is pending"){
      statusColors[0] = Colors.green[400];
      statusColors[1] = Colors.green[400];
      statusColors[2] = Colors.purple;
      for(int i = 3; i < 7; i++){
        statusColors[i] = Colors.grey;
      }
    }
    else if(currentStatus == "Work in progress"){
      for(int i = 0; i < 4; i++){
        statusColors[i] = Colors.green[400];
      }
      statusColors[4] = Colors.purple;
      statusColors[5] = Colors.grey;
      statusColors[6] = Colors.grey;
    }
    else if(currentStatus == "Work completed"){
      for(int i = 0; i < 7; i ++){
        statusColors[i] = Colors.green;
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          )
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
            if(complaint['status'] != "Closed with due justification")
            _buildProgressIndicator(statusColors, width),
            // Center(
            //   child: Text(
            //     complaint["status"] ?? "",
            //     style: TextStyle(
            //       fontSize: 20,
            //       color: (complaint["status"] == 'completed')
            //           ? Colors.green
            //           : Colors.redAccent,
            //     ),
            //   ),
            // ),
            SizedBox(height: 20,),
            if(complaint["admin_remark"] != null)
            _buildRequestDetail(complaint["admin_remark"]),
            if(complaint["admin_remark"] != null)
            SizedBox(height: 20,),
            if(complaint["images"] != null)
              OutlinedButton(
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
                child: Text("Show Images")
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
            if (complaint != null &&
                complaint["status"] == "Pending transmission")
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                  onTap: () async {
                    await widget.db
                        .deleteRequest(widget.complaint['complaint_id']);
                    Navigator.pop(context);
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

  _buildProgressIndicator(List<Color> statusColors, double width){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _buildProgressIcon(statusColors[0], iconData: MdiIcons.clipboardClockOutline),
              Text(
                'Registered on: ' + '\n' + dateTimeString(complaint['created_time']),
                softWrap: true,
              )
            ],),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProgressLine(statusColors[1], 25),
                _buildProgressIcon(statusColors[2], iconData: MdiIcons.clockTimeThreeOutline,),
                _buildProgressLine(statusColors[3], 25),
                _buildProgressIcon(statusColors[4], iconData: Icons.hourglass_bottom),
                _buildProgressLine(statusColors[5], 25),
              ],
            ),
            Row(
              children: [
                _buildProgressIcon(statusColors[6], iconData: Icons.check_circle_outline),
                if(complaint['completed_time'] != null)
                Text('Completed on: ' + '\n' + dateTimeString(complaint['completed_time'])),
              ],
            )
            
          ],
        ),
      ],
    );
  }

  _buildProgressIcon(Color color, {IconData iconData = Icons.check_circle}){
    return IconButton(
      icon: Icon(
        iconData,
        color: color,
        size: 30,
      ),
      onPressed: null,
    );
  }

  _buildProgressLine(Color color, double height){
    return SizedBox(
      height: height,
      child: VerticalDivider(
        thickness: 2.5,
        color: color,
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
            Flexible(child: Text(
                loc,
                style: TextStyle(fontSize: 17),
              )),
          ],
        ),
      );
    }
  }


String dateTimeString( String utcDateTime) {
  var parseDateTime = DateTime.parse(utcDateTime);
  final localDateTime = parseDateTime.toLocal();

  var dateTimeFormat = DateFormat("dd/MM/yyyy hh:mm:ss aaa");

  return dateTimeFormat.format(localDateTime);
}
