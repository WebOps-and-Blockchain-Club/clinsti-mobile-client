import 'dart:convert';

import 'package:app_client/services/database.dart';
import 'package:flutter/material.dart';

class ComplaintImages extends StatefulWidget {
  final List<dynamic> imgNames;
  final DatabaseService db;
  ComplaintImages({ this.imgNames, this.db });

  @override
  _ComplaintImagesState createState() => _ComplaintImagesState();
}

class _ComplaintImagesState extends State<ComplaintImages> {
  List<String> imageString = [];
  bool loading = false;
  @override
  initState(){
    print(widget.imgNames);
    super.initState();
    _fetchImages();
  }

  _fetchImages()async{
    setState(() {
      loading = true;
    });
    try {
      for(var i=0; i<widget.imgNames.length; i++){
        String tempImg = await widget.db.getImage(widget.imgNames[i]);
        imageString.add(tempImg);
      }
      setState(() {});
    } catch(e) {

    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading? Center(child: CircularProgressIndicator(),): Container(
                  child: ListView.builder(
                    itemCount: imageString.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Image.memory(
                          base64Decode(imageString[index])
                        ),
                      );
                    },
                  ),
                ));
  }
}