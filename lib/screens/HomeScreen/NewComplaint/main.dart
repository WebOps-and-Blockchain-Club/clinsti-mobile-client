import 'dart:convert';
import 'dart:io';
import 'package:app_client/screens/Map/main.dart';
import 'package:app_client/services/database.dart';
import 'package:app_client/services/newRequestStore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:app_client/widgets/formErrorMessage.dart';

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
  String error = "";
  String error1;
  String errormessagedesc;
  String errormessagelocation;
  String errormessagezoneselect;
  String errormessagewasteselect;
  DatabaseService _db;
  bool errorboxdesc = false;
  bool errorboxloc = false;
  bool loading = false;
  bool imgLoading = false;
  bool geoLoc = false;
  FocusNode _descnode;
  FocusNode _locationnode;
  FocusNode _zonenode;
  FocusNode _wastenode;
  bool _descfocused = false;
  bool _locationfocused = false;
  NewRequestStore _storage;

  final _formKey = GlobalKey<FormState>();
  final List<String> zones = [
    "Academic Zone",
    "Hostel Zone",
    "Residential Zone"
  ];
  final List<String> types = [
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
  ];
  _selectLocation(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapSelect(
                loc: compLocation.text == "" ? null : compLocation.text)));
    if (result != null) {
      setState(() {
        compLocation.text = result;
        geoLoc = true;
      });
    }
    storeRequest();
  }

  getStoredRequest() async {
    try {
      var stored = await _storage.getStoredRequest();
      if (stored != null) {
        setState(() {
          String loc = stored["location"] ?? "";
          try {
            jsonDecode(loc);
            setState(() {
              geoLoc = true;
            });
          } catch (e) {}
          compDescription.text = stored["description"] ?? "";
          compLocation.text = loc;
          if(zones.contains(stored["zone"])) zoneValue = stored["zone"];
          if(types.contains(stored["type"])) typeValue = stored["type"];
          if(stored["imgPath"] != "") {
            compressedImagesPath = [];
            compressedImagesPath = (stored["imgPath"].toString()).split(",");
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  storeRequest() {
    try {
      _storage.setStoredRequest({
        "description": compDescription.text.toString(),
        "location": compLocation.text.toString(),
        "zone": zoneValue.toString(),
        "type": typeValue.toString(),
        "imgPath": compressedImagesPath.join(",")
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _db = Provider.of<DatabaseService>(context, listen: false);
    });
    _storage = new NewRequestStore();
    _descnode = FocusNode();
    _descnode.addListener(_handleFocusChange);
    _locationnode = FocusNode();
    _locationnode.addListener(_handleFocusChange);
    _zonenode = FocusNode();
    _wastenode = FocusNode();
    getStoredRequest();
  }

  postRequest() async {
    setState(() {
      loading = true;
      error = "";
    });
    try {
      await _db.postRequest(compDescription.text, compLocation.text, typeValue,
          zoneValue, compressedImagesPath);
      Fluttertoast.showToast(
          msg: "Request posted",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green,
          textColor: Colors.black,
          fontSize: 14.0);
      setState(() {
        compDescription.text = "";
        compLocation.text = "";
        typeValue = null;
        zoneValue = null;
        geoLoc = false;
      });
      clearImages();
      _storage.deleteRequest();
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
    setState(() {
      loading = false;
    });
  }

  void _handleFocusChange() {
    if (_descnode.hasFocus != _descfocused) {
      setState(() {
        _descfocused = _descnode.hasFocus;
      });
    } else if (_locationnode.hasFocus != _locationfocused) {
      setState(() {
        _locationfocused = _locationnode.hasFocus;
      });
    }
    storeRequest();
  }

  @override
  void dispose() {
    _descnode.dispose();
    _locationnode.dispose();
    _zonenode.dispose();
    _wastenode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            color: Colors.pinkAccent[50],
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Text(
                        "Post your Complaint here",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.white,
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(10.0)),
                      child: TextFormField(
                        focusNode: _descnode,
                        onTap: () {
                          if (_descfocused) {
                            _descnode.unfocus();
                          } else {
                            _descnode.requestFocus();
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
                            labelText: 'Description',
                            labelStyle: TextStyle(
                                color: _descnode.hasFocus
                                    ? (errorboxdesc
                                        ? Colors.red[800]
                                        : Colors.green)
                                    : Colors.grey)),
                        validator: (val) {
                          if (val.length < 10) {
                            setState(() {
                              errorboxdesc = true;
                              errormessagedesc =
                                  'Please give us more information';
                            });

                            return '';
                          } else {
                            setState(() {
                              errormessagedesc = null;
                            });
                            return null;
                          }
                        },
                        maxLines: null,
                        controller: compDescription,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  errorMessages(errormessagedesc),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.white,
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(10.0)),
                      child: TextFormField(
                        focusNode: _locationnode,
                        onTap: () {
                          if (_locationfocused) {
                            _locationnode.unfocus();
                          } else {
                            _locationnode.requestFocus();
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
                            labelText: 'Location',
                            labelStyle: TextStyle(
                                color: _locationnode.hasFocus
                                    ? (errorboxloc
                                        ? Colors.red[800]
                                        : Colors.green)
                                    : Colors.grey),
                            suffixIcon: geoLoc
                                ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _selectLocation(context);
                                      },
                                      icon: Icon(
                                        Icons.edit_location,
                                        color: Colors.green,
                                      )),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            geoLoc = false;
                                            compLocation.clear();
                                          });
                                        },
                                        icon: Icon(
                                          Icons.location_off,
                                          color: Colors.green,
                                        ))
                                  ],
                                )
                                : IconButton(
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      _selectLocation(context);
                                    },
                                  )
                                  ),
                        validator: (val) {
                          if (val.length < 5) {
                            setState(() {
                              errorboxloc = true;
                              errormessagelocation =
                                  'Please write few more words';
                            });

                            return '';
                          } else {
                            setState(() {
                              errormessagelocation = null;
                            });
                            return null;
                          }
                        },
                        controller: geoLoc
                            ? TextEditingController(text: "Location Added")
                            : compLocation,
                        style: TextStyle(
                            color: geoLoc ? Colors.green : Colors.black),
                        maxLines: null,
                        readOnly: geoLoc,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  errorMessages(errormessagelocation),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.white,
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(10.0)),
                      child: Focus(
                        focusNode: _zonenode,
                        onFocusChange: (bool focus) {
                          setState(() {});
                        },
                        child: Listener(
                          onPointerDown: (_) {
                            FocusScope.of(context).requestFocus(_zonenode);
                          },
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
                            value: zoneValue,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            isExpanded: true,
                            style: const TextStyle(color: Colors.black87),
                            onChanged: (String newValue) {
                              setState(() {
                                zoneValue = newValue;
                                storeRequest();
                              });
                            },
                            items: zones
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            validator: (val) {
                              if (val == null) {
                                setState(() {
                                  errormessagezoneselect = 'Please Select';
                                });
                                return '';
                              } else {
                                setState(() {
                                  errormessagezoneselect = null;
                                });
                                return null;
                              }
                            },
                            hint: Text(
                              'Zone',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  errorMessages(errormessagezoneselect),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Material(
                        elevation: 5.0,
                        shadowColor: Colors.white,
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.all(const Radius.circular(10.0)),
                        child: Focus(
                          focusNode: _wastenode,
                          onFocusChange: (bool focus) {
                            setState(() {});
                          },
                          child: Listener(
                            onPointerDown: (_) {
                              FocusScope.of(context).requestFocus(_wastenode);
                            },
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
                              value: typeValue,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              isExpanded: true,
                              style: const TextStyle(color: Colors.black87),
                              validator: (val) {
                                if (val == null) {
                                  setState(() {
                                    errormessagewasteselect = 'Please Select';
                                  });
                                  return '';
                                } else {
                                  setState(() {
                                    errormessagewasteselect = null;
                                  });
                                  return null;
                                }
                              },
                              onChanged: (String newValue) {
                                setState(() {
                                  typeValue = newValue;
                                  storeRequest();
                                });
                              },
                              items: types.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              hint: Text(
                                'Type of Waste',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  errorMessages(errormessagewasteselect),
                  SizedBox(
                    height: 20,
                  ),
                  if(imgLoading) Center(
                    child: Text(
                      "Image Loading...",
                      style: TextStyle(
                        fontSize: 16.0
                      ),
                      )
                    ),
                  if (compressedImagesPath.length != 0) dispImages(),
                  SizedBox(
                    height: 20,
                  ),
                  if (compressedImagesPath.length != 0)
                    Center(
                      child: Text("Long press the image to delete"),
                    ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        elevation: MaterialStateProperty.all(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child:
                            Text('Add Images', style: TextStyle(fontSize: 18)),
                      ),
                      onPressed: () async {
                        await loadAssets();
                        if (images.length != 0) {
                          await compressImages();
                        }
                      },
                    ),
                    if (compressedImagesPath.length != 0)
                      SizedBox(
                        width: 10,
                      ),
                    if (compressedImagesPath.length != 0)
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          elevation: MaterialStateProperty.all(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('Clear All Images',
                              style: TextStyle(fontSize: 18)),
                        ),
                        onPressed: clearImages,
                      ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  if (error != null)
                    Center(
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
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        elevation: MaterialStateProperty.all(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('Submit Complaint',
                            style: TextStyle(fontSize: 18)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await postRequest();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
  }

  Widget dispImages() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: compressedImagesPath.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Card(
            child: GestureDetector(
              onLongPress: () async {
                setState(() {
                  compressedImagesPath.removeAt(index);
                  storeRequest();
                });
                await deleteImageFile(File(compressedImagesPath[index]));
              },
              child: Image.file(
                File(compressedImagesPath[index]),
                width: 300,
                height: 300,
                ),
              // child: AssetThumb(
              //   width: 300,
              //   height: 300,
              //   asset: image,
              // ),
            ),
          );
        },
      ),
    );
  }

  void clearImages() {
    setState(() {
      compressedImagesPath.removeRange(0, compressedImagesPath.length);
      storeRequest();
    });
    compressedImagesPath.forEach(
      (_img) async {
         await deleteImageFile(File(_img));
      });
  }

  Future<void> deleteImageFile(File file) async {
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    print(e);
  }
}

  Future<void> loadAssets() async {
    List<Asset> resultList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8,
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
      setState(() {
        error1 = e.toString();
      });
      Fluttertoast.showToast(
          msg: error1,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 14.0);
    }

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
        imgLoading = true;
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
    storeRequest();
    setState(() {
      imgLoading = false;
      images = [];
    });
  }

  Future<File> compressImage(File file) async {
    final filePath = file.absolute.path;
    final fileName = (filePath.split("/")).last;
    final lastIndex = fileName.lastIndexOf(new RegExp(r'.jp'));
    final String path = (await getApplicationDocumentsDirectory()).path;
    final splitted = fileName.substring(0, (lastIndex));
    final outPath = "$path/$splitted${fileName.substring(lastIndex)}";
    print(outPath);
    var result = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        quality: 70, minWidth: 1000, minHeight: 1000);
    return result;
  }
}
