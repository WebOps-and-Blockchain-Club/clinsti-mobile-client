import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class NewComplaintScreen extends StatefulWidget {
  @override
  _NewComplaintScreenState createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends State<NewComplaintScreen> {
  TextEditingController compLocation = TextEditingController();
  TextEditingController compDescription = TextEditingController();
  String dropdownValue;
  List<Asset> images = [];
  String error;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            maxLines: null,
            controller: compDescription,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
                labelText: 'Location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: null,
                )),
            controller: compLocation,
            maxLines: null,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton(
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['Bio-degradable', 'Plastic']
                .map<DropdownMenuItem<String>>((String value) {
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
            child: Text('Add Images'),
            onPressed: loadAssets,
          ),
          if (images.length != 0)
            SizedBox(
              width: 10,
            ),
          if (images.length != 0)
            ElevatedButton(
              child: Text('Clear'),
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
            child: Text('Submit Complaint'),
            onPressed: null,
          ),
        ),
      ],
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
              asset: image,
              width: 300,
              height: 300,
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
