import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelect extends StatefulWidget {
  final bool select;
  final String? loc;
  MapSelect({required this.loc, this.select = true});
  @override
  State<MapSelect> createState() => MapSelectState();
}

class MapSelectState extends State<MapSelect> {
  late LatLng _currentLocation;
  late Marker _markerCurrent;
  late LatLng? _selectedLocation;
  late Marker _markerSelected;
  late Set<Marker> _markers;

  late BitmapDescriptor locationIcon;

  MapType _mapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCam = CameraPosition(
    target: LatLng(12.9915, 80.2337),
    zoom: 16,
  );

  void initState() {
    super.initState();
    if (widget.loc != null) {
      setState(() {
        _selectedLocation = _getLocation(widget.loc!);
      });
    }

    init();
  }

  init() async {
    initMarkers();
    if (widget.select) {
      if (widget.loc == null) {
        await getCurrentLocation();
        await gotoCurrentLocation();
        selectCurrentLocation();
      } else {
        await gotoSelectedLocation();
        getCurrentLocation();
      }
    } else {
      if (widget.loc != null) {
        await gotoSelectedLocation();
      }
    }
  }

  initMarkers() {
    setState(() {
      _markerCurrent = Marker(markerId: MarkerId('current'));
      if (_selectedLocation != null) {
        _markerSelected = Marker(
            markerId: MarkerId('selected'), position: _selectedLocation!);
      } else {
        _markerSelected = Marker(markerId: MarkerId('selected'));
      }
      _markers = {_markerSelected, _markerCurrent};
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(48, 48)), 'assets/location.png')
          .then((onValue) {
        locationIcon = onValue;
      });
    });
  }

  LatLng? _getLocation(String loc) {
    try {
      var obj = jsonDecode(loc);
      return new LatLng(obj['Latitude'], obj['Longitude']);
    } catch (e) {
      return null;
    }
  }

  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
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
              orElse: () => Marker(markerId: MarkerId('Random')));
          _markers.remove(tempMarker);
          _markers.add(_markerCurrent);
        });
        return;
      });
    }
  }

  selectCurrentLocation() {
    _onTap(_currentLocation);
  }

  Future gotoCurrentLocation() async {
    // LocationPermission permission = await Geolocator.checkPermission();
    if (_controller != null && _currentLocation != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation, zoom: 16)));
    }
  }

  Future gotoSelectedLocation() async {
    if (_controller != null && _selectedLocation != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: _selectedLocation ?? _currentLocation, zoom: 16)));
    }
  }

  void _onTap(LatLng? latLng) {
    if (widget.select && latLng != null) {
      setState(() {
        _selectedLocation = latLng;
        _markerSelected =
            Marker(markerId: MarkerId("selected"), position: latLng);
        Marker tempMarker = _markers.firstWhere(
            (marker) => marker.markerId.value == "selected",
            orElse: () => Marker(markerId: MarkerId('Random')));
        _markers.remove(tempMarker);
        _markers.add(_markerSelected);
      });
    }
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
                "Latitude": _selectedLocation?.latitude,
                "Longitude": _selectedLocation?.longitude
              }).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () {
                      _toggleMapType();
                    }),
                ElevatedButton(
                  onPressed: () {
                    if (widget.select) {
                      if (_selectedLocation == null) {
                        print('select first');
                      } else {
                        _returnLoc(context);
                      }
                    } else {
                      _returnLoc(context);
                    }
                  },
                  child: Text(widget.select ? 'Select location' : "Back"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green[400]),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.my_location_rounded),
                    onPressed: () async {
                      await getCurrentLocation();
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
