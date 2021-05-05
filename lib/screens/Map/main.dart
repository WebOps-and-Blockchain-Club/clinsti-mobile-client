import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelect extends StatefulWidget {
  @override
  State<MapSelect> createState() => MapSelectState();
}

class MapSelectState extends State<MapSelect> {
  Marker _marker;
  MapType _mapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _intialPosition = new LatLng(12.9915, 80.2337);
  static final CameraPosition _initialCam = CameraPosition(
    target: LatLng(12.9915, 80.2337),
    zoom: 16,
  );

  void _onTap(LatLng latLng) {
    setState(() {
      _intialPosition = latLng;
      _marker = new Marker(markerId: MarkerId("Id-0"), position: latLng);
    });
  }

  void _onMapCreate(GoogleMapController controller) {
    setState(() {
      _marker =
          new Marker(markerId: MarkerId("Id-1"), position: _intialPosition);
      _controller.complete(controller);
    });
  }

  _toggleMapType() {
    setState(() {
      _mapType =
          _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  _returnLat(BuildContext context) {
    String cords = _intialPosition == null
        ? ""
        : jsonEncode({
            "latitude": _intialPosition.latitude,
            "longitude": _intialPosition.longitude
          });
    Navigator.pop(context, cords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              padding: EdgeInsets.all(1.0),
              onTap: _onTap,
              mapToolbarEnabled: false,
              markers: _marker == null ? {} : {_marker},
              mapType: _mapType,
              zoomControlsEnabled: false,
              myLocationEnabled: false,
              initialCameraPosition: _initialCam,
              onMapCreated: _onMapCreate,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () {
                      _toggleMapType();
                    }),
                ElevatedButton(
                    onPressed: () {
                      _returnLat(context);
                    },
                    child: Text('Select location'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
