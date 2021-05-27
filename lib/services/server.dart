import 'dart:convert';
import 'package:app_client/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Server {
  String baseUrl =
      "http://localhost:3000"; //TODO: put your local netwok config here
  final String signup = "/client/accounts/signup";
  final String signin = '/client/accounts/signin';
  var jsonHead = {'Content-Type': 'application/json'};
  var tokenHead = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI4MDUwNmRkMS1iZTJlLTQyOWUtOTUyNS00OTFmZjhkYWEyMGUiLCJfcGFzc3dvcmQiOiIkMmEkMTAkT0ptVlpROGRCaHg3emx4d0hud043TzcwLldFQ0VwWlZJSmg3NnMxY3g5YXJxWGF0UmJIUG0iLCJpYXQiOjE2MjA0MDg1NzIsImV4cCI6MTYyMzAwMDU3Mn0.cSymrAudwljetZIYTetypdPTyofY_96HtBlv-F92_uM'
  };
  SharedPreferences _prefs;

  Server() {
    init();
  }

  init() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    baseUrl = _prefs.getString('link') ?? "http://localhost:3000";
  }

  ////Account Requests
  ///SignUp
  Future<dynamic> signUp(String email, String password, String name) async {
    await init();
    var headers = {...jsonHead};
    var request = http.Request('POST', Uri.parse(baseUrl + signup));
    request.body =
        '{"name": "$name","email": "$email","password": "$password"}';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw (response);
    }
  }

  ///SignIn
  Future<dynamic> signIn(String email, String password) async {
    await init();
    var headers = {...jsonHead};
    var request =
        http.Request('POST', Uri.parse('$baseUrl/client/accounts/signin'));
    request.body = '{"email": "$email",   "password": "$password"}';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw (response);
    }
  }

  //View Profile
  Future getUserInfo(String token) async {
    await init();
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse('$baseUrl/client/accounts'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var convertedData = jsonDecode(await response.stream.bytesToString());
      User user = User.fromJson(convertedData, token);
      return user;
    } else {
      throw (response);
    }
  }

  ///Edit Profile
  Future updateProfile(String token, {String name, String email}) async {
    await init();
    if (name == null && email == null) {
      return;
    }
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('PATCH', Uri.parse('$baseUrl/client/accounts'));
    if (name == null) {
      request.body = '{"email":"$email"}';
    } else if (email == null) {
      request.body = '{"name":"$name"}';
    } else {
      request.body = '{"name":"$name", "email":"$email"}';
    }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      User user = User(token: token, email: email, name: name);
      return user;
    } else {
      throw (response);
    }
  }

  ///Change Password
  Future<dynamic> changePassword(
      String token, String oldPass, String newPass) async {
    await init();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('$baseUrl/api/changePassword'));
    request.body = '{"oldPassword": "$oldPass","newPassword":"$newPass"}';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw (response);
    }
  }

  ////Complaints Requests

  ///post request
  Future<dynamic> postRequest(String token, String description, String location,
      String type, String zone, List<String> imagesPath) async {
    await init();
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/client/complaints'));
    request.fields.addAll({
      'description': description,
      'location': location,
      'wasteType': type,
      'zone': zone
    });

    if(imagesPath.length != null){
      for(int i = 0; i < imagesPath.length; i++){
        request.files.add(await http.MultipartFile.fromPath('images', imagesPath[i]));
        print(imagesPath[i]);
      }
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
    } else {
      throw (response);
    }
  }

  ///get all complaints
  Future<dynamic> getComplaints(String token,
      {String zoneFilter,
      String statusFilter,
      int skip,
      int limit,
      String dateFrom,
      String dateTo}) async {
    await init();
    String url = "$baseUrl/client/complaints";
    List<String> querys = [];
    if (zoneFilter != null) querys.add('zone=$zoneFilter');
    if (statusFilter != null) querys.add('status=$statusFilter');
    if (skip != null) querys.add('skip=$skip');
    if (limit != null) querys.add('limit=$limit');
    if (dateFrom != null) querys.add('dateFrom=$dateFrom');
    if (dateTo != null) querys.add('dateFrom=$dateTo');
    String query = querys.join('&');
    if (query != null) url += '?$query';

    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw (response);
    }
  }

  /// get request by id
  Future<dynamic> getComplaint(String token, int id) async {
    await init();
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.Request('GET', Uri.parse('$baseUrl/client/complaints/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw (response);
    }
  }

  ///get image
  Future<dynamic> getImage(String token, String name) async {
    await init();
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.Request('GET', Uri.parse('$baseUrl/client/images/$name'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return (await response.stream.bytesToString());
    } else {
      throw (response);
    }
  }

  ///add Complaint feedback
  Future<dynamic> postRequestFeedback(
      String token, int id, int rating, String remark) async {
    await init();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseUrl/client/complaints/$id/feedback'));
    request.body = '''{"fbRating":$rating,"fbRemark":"$remark"}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 202) {
      return (await response.stream.bytesToString());
    } else {
      throw (response);
    }
  }

  Future<dynamic> postFeedback(String type, String feedback) async {
    await init();
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$baseUrl/client/feedback'));
    request.body = '''{"feedback":"$feedback","feedback_type":"$type"}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      return (await response.stream.bytesToString());
    } else {
      throw (response);
    }
  }

  Future<dynamic> deleteRequest(String token, int id) async {
    await init();
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.Request('DELETE', Uri.parse('$baseUrl/client/complaints/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return (await response.stream.bytesToString());
    } else {
      throw (response);
    }
  }
}
