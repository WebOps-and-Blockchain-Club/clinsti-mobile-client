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
  int _limit = 50;
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

  Future setSkip(int x) {
    _skip = x;
  }

  Future _setComplaints(dynamic arr) {
    _complaints = arr;
    notifyListeners();
  }

  Future _fetchComplaints() async {
    await _loadToken();
    try {
      dynamic arr = await http.getComplaints(_token,
          statusFilter: _statusFilter,
          zoneFilter: _zoneFilter,
          skip: _skip,
          limit: _limit);
      _setComplaints(arr);
    } catch (e) {}
    // _complaints = dummyComplaints;
  }

  Future getComplaint(int id) async {
    await _loadToken();
    try {
      dynamic complaint = await http.getComplaint(_token, id);
      return complaint;
    } catch (e) {}
  }

  Future next() async {}

  Future prev() async {}

  Future postRequest(
      String description, String location, String type, String zone,
      List<String> imgagesPath) async {
        
    await _loadToken();
    try {
      await http.postRequest(_token, description, location, type, zone, imgagesPath);
    } catch (e) {}
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

  var dummyComplaints = [
    {
      "complaint_id": 27,
      "_location": "IITMsa4csdsd",
      "created_time": "2021-05-07T17:39:57.307Z",
      "status": "Pending transmission"
    },
    {
      "complaint_id": 26,
      "_location": "IITMsa4csdsd",
      "created_time": "2021-05-07T17:39:44.291Z",
      "status": "Work in progress"
    },
    {
      "complaint_id": 25,
      "_location": "IITMsa4csdsd",
      "created_time": "2021-05-07T17:39:33.705Z",
      "status": "Pending transmission"
    },
    {
      "complaint_id": 24,
      "_location": "IITMsa4csdsd",
      "created_time": "2021-05-07T17:39:13.446Z",
      "status": "Pending transmission"
    },
    {
      "complaint_id": 23,
      "_location": "IITMsa4csdsd",
      "created_time": "2021-05-07T17:38:59.209Z",
      "status": "Work in progress"
    },
    {
      "complaint_id": 22,
      "_location": "IITMsa4csdsd",
      "created_time": "2021-05-07T17:38:45.653Z",
      "status": "Pending transmission"
    },
    {
      "complaint_id": 21,
      "_location": "IITMsa4csdsd",
      "created_time": "2021-05-07T17:38:33.960Z",
      "status": "Pending transmission"
    },
    {
      "complaint_id": 20,
      "_location": "IITMsa4csdsd",
      "created_time": "2021-05-07T17:38:20.336Z",
      "status": "Work in progress"
    },
    {
      "complaint_id": 19,
      "_location": "IITMsa4csdsd",
      "created_time": "2021-05-07T17:37:52.284Z",
      "status": "Pending transmission"
    },
    {
      "complaint_id": 18,
      "_location": "IITMsa4csdsd",
      "created_time": "2021-05-07T17:30:58.419Z",
      "status": "Pending transmission"
    }
  ];
}
