import 'dart:convert';

import 'package:app_client/services/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService extends ChangeNotifier {
  // const zone = req.query.zone?.toString().split(',')
  //   const "status" = req.query."status"?.toString().split(',')
  //   let dateFrom = req.query.dateFrom
  //   let dateTo = req.query.dateTo + 'T23:59:59.999Z"'

  //   const reqLimit = req.query.limit?.toString()
  //   const reqSkip = req.query.skip?.toString()

  Server http = new Server();
  SharedPreferences _prefs;
  String _token;
  String _statusFilter;
  String _zoneFilter;
  int _skip = 0;
  int _limit = 10;
  List<dynamic> _complaints = <dynamic>[];

  List<dynamic> get complaintS => _complaints ?? [];

  DatabaseService() {
    _initState();
  }

  _initState() async {
    notifyListeners();
    _token = null;
    await _loadToken();
    await _fetchComplaints();
  }

  Future _initDB() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  Future _loadToken() async {
    await _initDB();
    _token = _prefs.getString('token') ?? null;
    notifyListeners();
  }

  // Future _setToken(String token) async {
  //   await _initDB();
  //   _prefs.setString('token', token);
  //   _token = token;
  //   notifyListeners();
  // }

  // Future _resetoken() async {
  //   await _initDB();
  //   _prefs.remove('token');
  //   _token = null;
  //   notifyListeners();
  // }

  Future setStatusFilter(String filt) async {
    print(filt);
    if (filt == "all") {
      _statusFilter = null;
      await _fetchComplaints();
    } else {
      _statusFilter = filt;
      await _fetchComplaints();
    }
  }

  Future setZoneFilter(String filt) async {
    if (filt == "all") {
      _zoneFilter = null;
    } else {
      _zoneFilter = filt;
    }
    _fetchComplaints();
  }

  Future _fetchComplaints() async {
    await _loadToken();
    try {
      dynamic arr = await http.getComplaints(_token,
          statusFilter: _statusFilter,
          zoneFilter: _zoneFilter,
          skip: _skip,
          limit: _limit);

      _complaints = arr;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
    // _complaints = dummyComplaints;
  }

  Future getComplaint(int id) async {
    await _loadToken();
    try {
      dynamic complaint = await http.getComplaint(_token, id);
      return complaint;
    } catch (e) {}
  }

  Future next() async {
    try {
      _skip += _limit;
      await _fetchComplaints();
    } catch (e) {
      _skip -= _limit;
      await _fetchComplaints();
      throw (e);
    }
  }

  Future prev() async {
    try {
      if (_skip > 0) {
        _skip -= _limit;
      } else {
        throw "";
      }
      await _fetchComplaints();
    } catch (e) {
      _skip = 0;
      await _fetchComplaints();
      throw (e);
    }
  }

  Future postRequest(String description, String location, String type,
      String zone, List<String> imgagesPath) async {
    await _loadToken();
    try {
      await http.postRequest(
          _token, description, location, type, zone, imgagesPath);
    } catch (e) {}
  }

  Future postRequestFeedback(int id, int rating, String review) async {
    await _loadToken();
    try {
      await http.postRequestFeedback(_token, id, rating, review);
    } catch (e) {
      print("Error " + e.toString());
    }
  }

  // Future postFeedback(String type, String feedback) async{
  //   print('uess');
  //   await _loadToken();
  //   try{
  //     print(_token);
  //     print(type);
  //     print(feedback);
  //     var response = await http.postFeedback(type, feedback);
  //   }catch(e) {}
  // }

  Future synC() async {
    await _fetchComplaints();
  }

  Future deleteRequest(int id) async {
    await _loadToken();
    try {
      await http.deleteRequest(_token, id);
    } catch (e) {
      print("Error " + e.toString());
    }
  }

  Future getImage(String img) async {
    await _loadToken();
    String img = '1624425345393-962037609..png';
    try {
      dynamic imgData = await http.getImage(_token, img);
      return base64Encode(imgData);
    } catch (e) {
      print("Error "+ e.toString());
    }
  }

}
