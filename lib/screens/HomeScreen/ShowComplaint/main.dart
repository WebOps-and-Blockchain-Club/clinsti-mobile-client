import 'package:app_client/models/complaint.dart';
import 'package:app_client/screens/HomeScreen/Feedback/main.dart';
import 'package:flutter/material.dart';

class ShowComplaintScreen extends StatefulWidget {

  final Complaint complaint;

  ShowComplaintScreen({this.complaint});

  @override
  _ShowComplaintScreenState createState() => _ShowComplaintScreenState();
}

class _ShowComplaintScreenState extends State<ShowComplaintScreen> {
  bool isEditable = false;
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    location.text = widget.complaint.location;
    description.text = widget.complaint.description;

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
              enabled: isEditable,
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
              enabled: isEditable,
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
                color: (widget.complaint.status == 'completed') ? Colors.green : Colors.redAccent,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            if(widget.complaint.status == 'completed')
              Center(
                child: ElevatedButton(
                  child: Text(
                    'Feedback',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen())),
                ),
              ),
            if(widget.complaint.status != 'completed')
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      isEditable ? 'Submit Complaint' : 'Edit Complaint',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onPressed: (){
                    if(isEditable){
                      return showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text('Submit Complaint?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Yes'),
                                onPressed: () async {
                                  setState(() {
                                    isEditable = false;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        },
                      );
                    }
                    return showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text('Edit Complaint?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                setState(() {
                                  isEditable = true;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'Delete Complaint',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onPressed: null,
                ),
              ]),
          ],
        ),
      ),
    );
  }
}
