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

  @override
  Widget build(BuildContext context) {
    print(widget.complaint);
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
             Row(
              children: [
                Text(
                  widget.complaint['_location'],
                ),
                Spacer(),
                Icon(Icons.location_on),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(widget.complaint['description']),
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
                                  (widget.complaint == null
                                      ? 0
                                      : (widget.complaint["feedback_rating"] ?? 0)))
                              ? Icon(Icons.star)
                              : Icon(Icons.star_border),
                          color: (index <
                                  (widget.complaint == null
                                      ? 0
                                      : (widget.complaint["feedback_rating"] ?? 0)))
                              ? Colors.yellowAccent
                              : Colors.grey,
                          onPressed: () {
                                print(showSubmitButton);
                                print((widget.complaint != null &&
                                    widget.complaint["feedback_rating"] == null));
                                print(widget.complaint["feedback_remark"] == null);
                                if ((widget.complaint != null &&
                                        widget.complaint["feedback_rating"] == null) ||
                                    widget.complaint["feedback_remark"] == null ||
                                    showSubmitButton) {
                                      setState(() {
                                        widget.complaint["feedback_rating"] = index + 1;
                                        showSubmitButton = true;
                                      });
                                }
                              });
                    },
                  ),
                ),
              ),
            // if (widget.complaint != null &&
            //     widget.complaint["feedback_rating"] != null &&
            //     widget.complaint["feedback_rating"] != 0)
            if(widget.complaint["status"] == "Work completed" || widget.complaint["status"] == "Closed with due justification")
              (widget.complaint['feedback_remark'] == null)
              ? Form(
                key: _formKey,
                child: TextFormField(
                  maxLines: null,
                  controller: feedback,
                  readOnly: widget.complaint['status'] == "Closed with due justification",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  // enabled:
                  //     (widget.complaint != null && widget.complaint["feedback_remark"] == null),
                  decoration: InputDecoration(
                    hintText: widget.complaint['status'] == "Closed with due justification" ? 'Justification' : 'Feedback',
                  ),
                ),
              ) : Text(widget.complaint['feedback_remark']),
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
                        widget.complaint["feedback_remark"] = feedback.text;
                      });
                      await widget.db.postRequestFeedback(
                          widget.complaint['complaint_id'],
                          widget.complaint['feedback_rating'],
                          widget.complaint['feedback_remark']);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Feedback Submitted')));
                    }
                  },
                ),
              ),
            if (widget.complaint != null && widget.complaint["status"] != 'Work completed' && widget.complaint['status'] != "Closed with due justification")
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
                    // setState(() {
                    //   widget.complaint["status"] = "completed";
                    // });
                  },
                ),
              ]),
          ],
        ),
      ),
    );
  }
}