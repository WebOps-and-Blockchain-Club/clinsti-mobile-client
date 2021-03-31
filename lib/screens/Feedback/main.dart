import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackText = TextEditingController();
  String _feedbackTo;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        width: MediaQuery.of(context).size.width,
        color: Colors.blue[100],
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField(
                hint: Text(
                  'feedbackTo',
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
                items: <String>['Owzone', 'App']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                validator: (val) => val == null ? 'Please select' : null,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Feedback',
                  ),
                  maxLines: null,
                  controller: _feedbackText,
                  validator: (val) =>
                      val.length < 10 ? 'Please write few more' : null,
                ),
              ),
              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Submit')))
            ],
          ),
        ),
      ),
    );
  }
}
