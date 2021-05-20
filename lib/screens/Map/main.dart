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
  Marker _markerCurrent;
  LatLng _selectedLocation;
  Marker _markerSelected;
  Set<Marker> _markers;
  BitmapDescriptor locationIcon;

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
    selectCurrentLocation();
  }

  initMarkers() {
    _markerCurrent = Marker(markerId: MarkerId('current'));
    _markerSelected = Marker(markerId: MarkerId('selected'));
    _markers = {_markerSelected, _markerCurrent};
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/location.png')
        .then((onValue) {
      locationIcon = onValue;
    });
  }

  Future getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((currentLocation) {
      setState(() {
        _currentLocation =
            LatLng(currentLocation.latitude, currentLocation.longitude);
        _markerCurrent = Marker(
            markerId: MarkerId('current'),
            position: _currentLocation,
            onTap: selectCurrentLocation,
            icon: locationIcon);
        Marker tempMarker = _markers.firstWhere(
            (marker) => marker.markerId.value == "current",
            orElse: () => null);
        _markers.remove(tempMarker);
        _markers.add(_markerCurrent);
      });
      return;
    });
  }

  selectCurrentLocation() {
    _onTap(_currentLocation);
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
      Marker tempMarker = _markers.firstWhere(
          (marker) => marker.markerId.value == "selected",
          orElse: () => null);
      _markers.remove(tempMarker);
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
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
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
                    onPressed: () async {
                      getCurrentLocation();
                      gotoCurrentLocation();
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
