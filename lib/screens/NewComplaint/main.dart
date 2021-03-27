import "package:flutter/material.dart";

class NewComplaintScreen extends StatefulWidget {
  @override
  _NewComplaintScreenState createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends State<NewComplaintScreen> {

  TextEditingController compLocation = TextEditingController();
  TextEditingController compDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            maxLines: null,
            controller: compDescription,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Location',
              suffixIcon: IconButton(
                icon: Icon(Icons.location_on),
                onPressed: null,
              )
            ),
            controller: compLocation,
            maxLines: null,
          ),
        ),
        // SizedBox(
        //   height: 40,
        // ),
        SizedBox(
          height: 40,
        ),
        Center(
          child: ElevatedButton(
            child: Text('Add Images'),
            onPressed: null,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Center(
          child: ElevatedButton(
            child: Text('Submit Complaint'),
            onPressed: null,
          ),
        ),
      ],
    );
  }
}
