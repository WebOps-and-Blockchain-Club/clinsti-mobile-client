import 'dart:io';
import 'package:app_client/screens/Map/main.dart';
import 'package:app_client/services/database.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
  List<String> compressedImagesPath = [];
  String error;
  DatabaseService _db;
  bool geoLoc = false;
  final _formKey = GlobalKey<FormState>();

  _selectLocation(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapSelect()));
    if (result != null) {
      setState(() {
        compLocation.text = result;
        setState(() {
          geoLoc = true;
        });
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
    await _db.postRequest(compDescription.text, compLocation.text, typeValue,
        zoneValue, compressedImagesPath);
    setState(() {
      compDescription.text = "";
      compLocation.text = "";
      typeValue = null;
      zoneValue = null;
    });
    clearImages();
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
              readOnly: geoLoc,
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
              onPressed: () async {
                await loadAssets();
                if (images.length != 0) {
                  await compressImages();
                }
              },
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
                onPressed: clearImages,
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

  void clearImages() {
    setState(() {
      images.removeRange(0, images.length);
    });
    compressedImagesPath.removeRange(0, compressedImagesPath.length);
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

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return file;
  }

  Future<void> compressImages() async {
    File temp;
    for (int i = 0; i < images.length; i++) {
      temp = await getImageFileFromAssets(images[i]);
      temp = await compressImage(temp);
      compressedImagesPath.add(temp.path);
    }
  }

  Future<File> compressImage(File file) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"

    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    print(filePath);
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    print(outPath);
    var result = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        quality: 70, minWidth: 1000, minHeight: 1000);
    return result;
  }
}
