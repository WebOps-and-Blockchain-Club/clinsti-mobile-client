import 'package:app_client/screens/Map/main.dart';
import 'package:app_client/services/database.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class NewComplaintScreen extends StatefulWidget {
  @override
  _NewComplaintScreenState createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends State<NewComplaintScreen> {
  TextEditingController compLocation = TextEditingController();
  TextEditingController compDescription = TextEditingController();
  String zoneValue;
  String typeValue;
  List<Asset> images = [];
  String error;
  DatabaseService _db;
  final _formKey = GlobalKey<FormState>();

  _selectLocation(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapSelect()));
    if (result != null) {
      setState(() {
        compLocation.text = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _db = Provider.of<DatabaseService>(context, listen: false);
    });
  }

  postRequest() async {
    await _db.postRequest(
        compDescription.text, compLocation.text, typeValue, zoneValue);
    setState(() {
      compDescription.text = "";
      compLocation.text = "";
      typeValue = null;
      zoneValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              validator: (val) =>
                  val.length < 5 ? "please write few more words" : null,
              maxLines: null,
              controller: compDescription,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Location',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      _selectLocation(context);
                    },
                  )),
              validator: (val) =>
                  val.length < 5 ? "please write few more words" : null,
              controller: compLocation,
              maxLines: null,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonFormField(
              value: zoneValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (String newValue) {
                setState(() {
                  zoneValue = newValue;
                });
              },
              items: <String>[
                "Academic Zone",
                "Hostel Zone",
                "Residential Zone"
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
              validator: (val) => val == null ? "please select" : null,
              hint: Text(
                'zone',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonFormField(
              value: typeValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              style: const TextStyle(color: Colors.deepPurple),
              validator: (val) => val == null ? "please select" : null,
              onChanged: (String newValue) {
                setState(() {
                  typeValue = newValue;
                });
              },
              items: <String>[
                "Paper/Plastic",
                "Bottles",
                "Steel scrap",
                "Construction debris",
                "Food waste",
                "Furniture",
                "Equipment",
                "Package materials",
                "e-waste (Tubelight, Computer, Battery)",
                "Hazardous waste (chemical, oil, bitumen, empty chemical bottle)",
                "Bio-medical waste",
                "Others"
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
              hint: Text(
                'Type of Waste',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          if (images.length != 0) dispImages(),
          SizedBox(
            height: 40,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Add Images', style: TextStyle(fontSize: 18)),
              ),
              onPressed: loadAssets,
            ),
            if (images.length != 0)
              SizedBox(
                width: 10,
              ),
            if (images.length != 0)
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Clear', style: TextStyle(fontSize: 18)),
                ),
                onPressed: () {
                  setState(() {
                    images.removeRange(0, images.length);
                  });
                },
              ),
          ]),
          SizedBox(
            height: 40,
          ),
          Center(
            child: ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Submit Complaint', style: TextStyle(fontSize: 18)),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await postRequest();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dispImages() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Asset image = images[index];
          return Card(
            child: AssetThumb(
              width: 300,
              height: 300,
              asset: image,
            ),
          );
        },
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          selectionFillColor: "#ff11ab",
          selectionTextColor: "#ffffff",
          selectionCharacter: "✓",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#00BFFF",
          actionBarTitle: "Select Images",
          allViewTitle: "All Media",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
          lightStatusBar: true,
          statusBarColor: "#4169E1",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
      Fluttertoast.showToast(
          msg: error,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 14.0);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (resultList.length == 0) {
        print('No image selected');
        Fluttertoast.showToast(
            msg: 'No Image Selected',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 14.0);
      } else {
        images = resultList;
      }
    });
  }
}
