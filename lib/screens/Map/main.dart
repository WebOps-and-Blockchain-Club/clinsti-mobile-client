import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelect extends StatefulWidget {
  @override
  State<MapSelect> createState() => MapSelectState();
}

class MapSelectState extends State<MapSelect> {
  LatLng _currentLocation;
  Circle _circleCurrent;
  Set<Circle> _circles;

  LatLng _selectedLocation;
  Marker _markerSelected;
  Set<Marker> _markers;

  MapType _mapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCam = CameraPosition(
    target: LatLng(12.9915, 80.2337),
    zoom: 16,
  );

  void initState() {
    super.initState();
    init();
  }

  init() async {
    initMarkers();
    await getCurrentLocation();
    await gotoCurrentLocation();
    _onTap(_currentLocation);
  }

  initMarkers() {
    _circleCurrent = Circle(circleId: CircleId('current'));
    _circles = {_circleCurrent};
    _markerSelected = Marker(markerId: MarkerId('selected'));
    _markers = {_markerSelected};
  }

  Future getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((currentLocation) {
      print(currentLocation);
      setState(() {
        _currentLocation =
            new LatLng(currentLocation.latitude, currentLocation.longitude);
        _circleCurrent = Circle(
            circleId: CircleId('current'),
            center: _currentLocation,
            radius: 1,
            strokeColor: Color(0x5F4CAF50),
            fillColor: Colors.green,
            strokeWidth: 20);
        _circles.add(_circleCurrent);
      });
      return;
    });
  }

  Future gotoCurrentLocation() async {
    if (_controller != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation, zoom: 16)));
    }
  }

  void _onTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _markerSelected =
          Marker(markerId: MarkerId("selected"), position: latLng);
      _markers.add(_markerSelected);
    });
  }

  void _onMapCreate(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }

  _toggleMapType() {
    setState(() {
      _mapType =
          _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  _returnLoc(BuildContext context) {
    Navigator.pop(
        context,
        _selectedLocation == null
            ? ""
            : jsonEncode({
                "Latitude": _selectedLocation.latitude,
                "Longitude": _selectedLocation.longitude
              }).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              circles: _circles == null ? {} : _circles,
              padding: EdgeInsets.all(1.0),
              onTap: _onTap,
              mapToolbarEnabled: false,
              markers: _markers == null ? {} : _markers,
              mapType: _mapType,
              // zoomControlsEnabled: false,
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
                      if (_selectedLocation == null) {
                        print('select first');
                      } else {
                        _returnLoc(context);
                      }
                    },
                    child: Text('Select location')),
                IconButton(
                    icon: Icon(Icons.my_location_rounded),
                    onPressed: () {
                      gotoCurrentLocation();
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
