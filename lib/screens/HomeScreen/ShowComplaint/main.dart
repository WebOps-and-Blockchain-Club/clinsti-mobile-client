// import 'package:app_client/screens/HomeScreen/Feedback/main.dart';
// import 'package:app_client/screens/HomeScreen/ShowComplaint/resolveComplaintScreen.dart';
import 'package:app_client/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowComplaintScreen extends StatefulWidget {
  final dynamic complaint;
  final DatabaseService db;
  ShowComplaintScreen({this.complaint, this.db});

  @override
  _ShowComplaintScreenState createState() => _ShowComplaintScreenState();
}

class _ShowComplaintScreenState extends State<ShowComplaintScreen> {
  bool showSubmitButton = false;
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController feedback = TextEditingController();
  int requestId;
  final _formKey = GlobalKey<FormState>();
  dynamic _complaint;

  @override
  void initState() {
    super.initState();
    // {
    //   "complaint_id": 27,
    //   "_location": "IITMsa4csdsd",
    //   "created_time": "2021-05-07T17:39:57.307Z",
    //   "status": "Pending transmission"
    // },
    location.text = widget.complaint["_location"];
    requestId = widget.complaint["complaint_id"];
    // requestId = widget.complaint['complaint_id'];
    getComplaint();
    // {complaint_id: 33,
    // description: hfhbebifwbuifw, _
    // location: all Homes,
    // waste_type: Furniture,
    // zone: Academic Zone,
    // status: Pending transmission,
    // created_time: 2021-05-20T07:39:14.150Z,
    // completed_time: null,
    // images: null,
    // feedback_rating: null,
    // feedback_remark: null,
    // admin_remark: null}
  }

  Future getComplaint() async {
    _complaint = await widget.db.getComplaint(widget.complaint["complaint_id"]);
    print(_complaint);
    setState(() {
      description.text = _complaint["description"];
      location.text = _complaint["_location"];
      feedback.text = _complaint["feedback_remark"] ?? "";
    });
    setState(() {});
    // {complaint_id: 33,
    // description: hfhbebifwbuifw,
    // _location: locatiosdas,
    // waste_type: Furniture,
    // zone: Academic Zone,
    // status: Pending transmission,
    // created_time: 2021-05-20T07:39:14.150Z,
    // completed_time: null,
    // images: null,
    // feedback_rating: null,
    // feedback_remark: null,
    // admin_remark: null}
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Complaint ID: ' + widget.complaint["complaint_id"].toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: location,
              maxLines: null,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: null,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: description,
              maxLines: null,
            ),
            SizedBox(
              height: 20,
            ),

            // Container(
            //   height: 200,
            //   child: ListView.builder(
            //     itemCount: complaint.images_url.length,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       return Card(
            //         child: Image.network(
            //           complaint.images_url[index],
            //           height: 150,
            //           width: 150,
            //           loadingBuilder: (BuildContext context, Widget child,
            //               ImageChunkEvent loadingProgress) {
            //             if (loadingProgress == null) return child;
            //             return Center(
            //               child: CircularProgressIndicator(
            //                 value: loadingProgress.expectedTotalBytes != null
            //                     ? loadingProgress.cumulativeBytesLoaded /
            //                     loadingProgress.expectedTotalBytes
            //                     : null,
            //               ),
            //             );
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            Text(
              'Registered on: ' + widget.complaint["created_time"].toString(),
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Status: ' + widget.complaint["status"].toString(),
              style: TextStyle(
                fontSize: 20,
                color: (widget.complaint["status"] == 'completed')
                    ? Colors.green
                    : Colors.redAccent,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            if (widget.complaint["status"] == 'Work completed')
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
                                  (_complaint == null
                                      ? 0
                                      : (_complaint["fbRating"] ?? 0)))
                              ? Icon(Icons.star)
                              : Icon(Icons.star_border),
                          color: (index <
                                  (_complaint == null
                                      ? 0
                                      : (_complaint["fbRating"] ?? 0)))
                              ? Colors.yellowAccent
                              : Colors.grey,
                          onPressed: () {
                            if ((_complaint != null &&
                                    _complaint["fbRating"] == null &&
                                    _complaint["fbRating"] == 0) ||
                                _complaint["fbReview"] == null ||
                                showSubmitButton) {
                              setState(() {
                                _complaint["fbRating"] = index + 1;
                                showSubmitButton = true;
                              });
                            }
                          });
                    },
                  ),
                ),
              ),
            if (_complaint != null &&
                _complaint["fbRating"] != null &&
                _complaint["fbRating"] != 0)
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
                  enabled:
                      (_complaint != null && _complaint["fbReview"] == null),
                  decoration: InputDecoration(
                    hintText: 'Feedback',
                  ),
                ),
              ),
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
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        showSubmitButton = false;
                        _complaint["fbReview"] = feedback.text;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Feedback Submitted')));
                    }
                  },
                ),
              ),
            if (_complaint != null && _complaint["status"] != 'Work completed')
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
                  onPressed: () {
                    setState(() {
                      _complaint["status"] = "completed";
                    });
                  },
                ),
              ]),
          ],
        ),
      ),
    );
  }
}
