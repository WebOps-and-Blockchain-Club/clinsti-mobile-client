import 'package:app_client/models/complaint.dart';
import 'package:app_client/screens/HomeScreen/Feedback/main.dart';
import 'package:app_client/screens/HomeScreen/ShowComplaint/resolveComplaintScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowComplaintScreen extends StatefulWidget {

  Complaint complaint;
  ShowComplaintScreen({this.complaint});

  @override
  _ShowComplaintScreenState createState() => _ShowComplaintScreenState();
}

class _ShowComplaintScreenState extends State<ShowComplaintScreen> {
  bool showSubmitButton = false;
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController feedback = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    location.text = widget.complaint.location;
    description.text = widget.complaint.description;
    feedback.text = widget.complaint.fbReview ?? null;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint ID: ' + widget.complaint.complaintId),
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
              'Registered on: ' + widget.complaint.timestamp,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Status: ' + widget.complaint.status,
              style: TextStyle(
                fontSize: 20,
                color: (widget.complaint.status == 'completed')
                    ? Colors.green
                    : Colors.redAccent,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            if(widget.complaint.status == 'completed')
              Center(
                child: Container(
                  width: 0.67*width,
                  height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, int index) {
                        return IconButton(
                            icon: (index < (widget.complaint.fbRating ?? 0)) ? Icon(Icons.star) : Icon(Icons.star_border),
                            color: (index < (widget.complaint.fbRating ?? 0)) ? Colors.yellowAccent : Colors.grey,
                            onPressed: () {
                              if((widget.complaint.fbRating == null && widget.complaint.fbRating == 0) || widget.complaint.fbReview == null || showSubmitButton) {
                                setState(() {
                                  widget.complaint.fbRating = index + 1;
                                  showSubmitButton = true;
                                });
                              }
                            }
                        );
                      },
                    ),
                ),
              ),
            if(widget.complaint.fbRating != null && widget.complaint.fbRating != 0)
              Form(
                key: _formKey,
                child: TextFormField(
                  maxLines: null,
                  controller: feedback,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  enabled: (widget.complaint.fbReview == null),
                  decoration: InputDecoration(
                    hintText: 'Feedback',
                  ),
                ),
              ),
            SizedBox(height: 20,),
            if(showSubmitButton)
              Center(
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('Submit Feedback', style: TextStyle(fontSize: 18)),
                  ),
                  onPressed: (){
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        showSubmitButton = false;
                        widget.complaint.fbReview = feedback.text;
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Feedback Submitted')));
                    }
                  },
                ),
              ),
            if(widget.complaint.status != 'completed')
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: [

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
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          ResolveComplaintScreen(complaintId: widget.complaint
                              .complaintId,))),
                ),
              ]),
          ],
        ),
      ),
    );
  }
}
