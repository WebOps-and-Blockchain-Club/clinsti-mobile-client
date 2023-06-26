import 'package:app_client/services/database.dart';
import 'package:app_client/widgets/formErrorMessage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FeedbackWrapper extends StatefulWidget {
  @override
  _FeedbackWrapperState createState() => _FeedbackWrapperState();
}

class _FeedbackWrapperState extends State<FeedbackWrapper> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => DatabaseService(), child: FeedbackScreen());
  }
}

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late DatabaseService _db;
  final TextEditingController _feedbackText = TextEditingController();
  String? _feedbackTo;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String? error;
  String? errormessagefselect;
  String? errormessagefeedback;
  bool errorbox = false;
  late FocusNode _node;
  bool _focused = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _db = Provider.of<DatabaseService>(context, listen: false);
    });
    _node = FocusNode();
    _node.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_node.hasFocus != _focused) {
      setState(() {
        _focused = _node.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);

    _node.dispose();
    super.dispose();
  }

  _submitFeedback() async {
    setState(() {
      loading = true;
    });
    try {
      if (_feedbackTo != null) {
        await _db.postFeedback(_feedbackTo!, _feedbackText.text);
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Thank you for your feedback",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.green,
            textColor: Colors.black,
            fontSize: 14.0);
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      if (error != null) {
        final snackBar = SnackBar(
          content: Text(
            error!,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: BackButton(),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              width: MediaQuery.of(context).size.width,
              //color: Colors.blue[100],
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        'Feedback',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Material(
                      elevation: 5.0,
                      shadowColor: Colors.white,
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(10.0)),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          errorStyle: TextStyle(height: 0),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 0.0),
                              borderRadius: BorderRadius.all(
                                  const Radius.circular(10.0))),
                        ),
                        hint: Text(
                          'Select feedback type',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        value: _feedbackTo,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? v) {
                          if (v != null) {
                            setState(() {
                              _feedbackTo = v;
                            });
                          }
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
                        validator: (val) {
                          if (val == null) {
                            setState(() {
                              errormessagefselect = 'Please Select';
                            });
                            return '';
                          } else {
                            setState(() {
                              errormessagefselect = null;
                            });
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    errorMessages(errormessagefselect),
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                      elevation: 5.0,
                      shadowColor: Colors.white,
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(10.0)),
                      child: TextFormField(
                          focusNode: _node,
                          onTap: () {
                            if (_focused) {
                              _node.unfocus();
                            } else {
                              _node.requestFocus();
                            }
                          },
                          decoration: InputDecoration(
                              errorStyle: TextStyle(height: 0),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(10.0))),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 0.0),
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(10.0))),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              labelText: 'How can we improve?',
                              labelStyle: TextStyle(
                                  color: _focused
                                      ? (errorbox
                                          ? Colors.red[800]
                                          : Colors.green)
                                      : Colors.black87)),
                          maxLines: 5,
                          controller: _feedbackText,
                          validator: (val) {
                            if (val != null && val.length < 10) {
                              setState(() {
                                errorbox = true;
                                errormessagefeedback =
                                    'Please give us more information';
                              });

                              return '';
                            } else {
                              setState(() {
                                errormessagefeedback = null;
                              });
                              return null;
                            }
                          }),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    errorMessages(errormessagefeedback),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              elevation: MaterialStateProperty.all(5),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                _submitFeedback();
                              }
                            },
                            child: loading
                                ? CircularProgressIndicator()
                                : Padding(
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
          ),
        ],
      ),
    );
  }
}
