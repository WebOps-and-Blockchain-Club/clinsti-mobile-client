import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:app_client/services/google_map.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:place_picker/place_picker.dart';

class NewComplaintScreen extends StatefulWidget {
  const NewComplaintScreen({Key key}) : super(key: key);

  static final kInitialPosition = LatLng(12.9915, 80.2337);
  @override
  _NewComplaintScreenState createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends State<NewComplaintScreen> {
  TextEditingController compLocation = TextEditingController();
  TextEditingController compDescription = TextEditingController();
  String dropdownValue;
  List<Asset> images = [];
  String error;
  String apiKey = 'AIzaSyBx8CFPjFvy889_ejFVJctYruobAlziKZk';
  PickResult selectedPlace;

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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlacePicker(
                              apiKey: apiKey,
                              initialPosition:
                                  NewComplaintScreen.kInitialPosition,
                              useCurrentLocation: true,
                              selectInitialPosition: true,

                              //usePlaceDetailSearch: true,
                              onPlacePicked: (result) {
                                selectedPlace = result;
                                Navigator.of(context).pop();
                                setState(() {});
                              },
                              forceSearchOnZoomChanged: true,
                              automaticallyImplyAppBarLeading: false,
                              //autocompleteLanguage: "ko",
                              //region: 'au',

                              selectedPlaceWidgetBuilder: (_, selectedPlace,
                                  state, isSearchBarFocused) {
                                print(
                                    "state: $state, isSearchBarFocused: $isSearchBarFocused");
                                return isSearchBarFocused
                                    ? Container()
                                    : FloatingCard(
                                        bottomPosition:
                                            0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                        leftPosition: 0.0,
                                        rightPosition: 0.0,
                                        width: 500,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: state == SearchingState.Searching
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            // ignore: deprecated_member_use
                                            : RaisedButton(
                                                child: Text("Pick Here"),
                                                onPressed: () {
                                                  // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                                  //            this will override default 'Select here' Button.
                                                  // TO BE ADDED: Taking out the output address
                                                  print(
                                                      "do something with [selectedPlace] data");
                                                  print(selectedPlace);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                      );
                              },
                              pinBuilder: (context, state) {
                                if (state == PinState.Idle) {
                                  return Icon(Icons.favorite_border);
                                } else {
                                  return Icon(Icons.favorite);
                                }
                              },
                            );
                          },
                        ),
                      );
                    })),
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
            items: <String>['Bio-degradable', 'Plastic', 'Other']
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

// () => Navigator.push(
//                       context,
//                        MaterialPageRoute(
//                          builder: (context) => GoogleMapScreen(),
//                        ))

// void showPlacePicker() async {
//     LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => PlacePicker(
//               apiKey,
//             )));

//     // Handle the result in your way
//     print(result);
//   }
