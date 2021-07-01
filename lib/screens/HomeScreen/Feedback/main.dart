import 'package:app_client/services/server.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackText = TextEditingController();
  String _feedbackTo;
  final _formKey = GlobalKey<FormState>();
  Server _server = Server();
  bool loading = false;
  String error;

  _submitFeedback() async {
    setState(() {
      loading = true;
    });
    try{
      await _server.postFeedback(_feedbackTo, _feedbackText.text);
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Thank you for your feedback",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 14.0
      );
    } catch(e) {
      setState(() {
        error = e;
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        width: MediaQuery.of(context).size.width,
        //color: Colors.blue[100],
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                hint: Text(
                  'Select feedback type',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                value: _feedbackTo,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                isExpanded: true,
                style: const TextStyle(color: Colors.deepPurple),
                onChanged: (String v) {
                  setState(() {
                    _feedbackTo = v;
                  });
                },
                items: <String>[
                  "Engineering Unit",
                  "Administration",
                  "App development team"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                validator: (val) => val == null ? 'Please select' : null,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'How can we improve?',
                ),
                maxLines: null,
                controller: _feedbackText,
                validator: (val) =>
                    val.length < 10 ? 'Please write few more' : null,
              ),
              SizedBox(
                height: 20,
              ),
              if(error != null) Center(
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red),
                  ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _submitFeedback();
                        }
                      },
                      child: loading?CircularProgressIndicator(): Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Send Feedback',
                          style: TextStyle(fontSize: 18),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}