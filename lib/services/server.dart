import 'dart:convert';
import 'dart:io';
import 'package:app_client/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Server {
  String baseUrl = "http://localhost:3000"; //TODO: Add server URI here
  final String signup = "/client/accounts/signup";
  final String signin = '/client/accounts/signin';
  var jsonHead = {'Content-Type': 'application/json'};
  SharedPreferences? prefs;

  Server({this.prefs}) {
    init();
  }

  init() async {}

  ////Account Requests
  ///SignUp
  Future<dynamic> signUp(String email, String password, String name) async {
    await init();
    var headers = {...jsonHead};
    var request = http.Request('POST', Uri.parse(baseUrl + signup));
    request.body =
        '{"name": "$name","email": "$email","password": "$password"}';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }

  ///Resend Verification Mail
  Future<dynamic> resendVerificationMail(String token) async {
    await init();
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET', Uri.parse('$baseUrl/client/accounts/resend-verification-mail'));
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }

  ///SignIn
  Future<dynamic> signIn(String email, String password) async {
    await init();
    var headers = {...jsonHead};
    var url = Uri.parse('$baseUrl/client/accounts/signin');
    var body = {'email': email, 'password': password};

    try {
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(body));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw response.body;
      }
    } on SocketException {
      throw 'server error';
    } catch (e) {
      throw e;
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
  Future updateProfile(String token,
      {String? name, required String email}) async {
    await init();
    if (name == null) {
      return;
    }
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('PATCH', Uri.parse('$baseUrl/client/accounts'));
    request.body = '{"name":"$name"}';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        User user = User(token: token, name: name, email: email);
        return user;
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
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
    var request = http.Request(
        'POST', Uri.parse('$baseUrl/client/accounts/changePassword'));
    request.body = '{"oldPassword": "$oldPass","newPassword":"$newPass"}';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }

  ///otp request
  Future<dynamic> getOtp(String email) async {
    await init();
    var headers = {...jsonHead};
    var request = http.Request(
        'GET', Uri.parse('$baseUrl/client/accounts/resetpassword'));
    request.body = '{"email": "$email"}';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }

  ///reset password
  Future<dynamic> resetPassword(
      String email, String otp, String password) async {
    await init();
    var headers = {...jsonHead};
    var request = http.Request(
        'POST', Uri.parse('$baseUrl/client/accounts/resetpassword'));
    request.body =
        '{"email": "$email", "otp": "$otp",   "password": "$password"}';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }

  ////Complaints Requests

  ///post request
  Future<dynamic> postRequest(String token, String description, String location,
      String? type, String? zone, List<String>? imagesPath) async {
    await init();
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/client/complaints'));
    request.fields.addAll({
      'description': description,
      'location': location,
      'wasteType': type ?? "",
      'zone': zone ?? ""
    });

    if (imagesPath != null) {
      for (int i = 0; i < imagesPath.length; i++) {
        request.files
            .add(await http.MultipartFile.fromPath('images', imagesPath[i]));
      }
    }

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        print(await response.stream.bytesToString());
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }

  ///get all complaints
  Future<dynamic> getComplaints(String token,
      {String? zoneFilter,
      String? statusFilter,
      int? skip,
      int? limit,
      String? dateFrom,
      String? dateTo}) async {
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
    url += '?$query';

    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var complaints = jsonDecode(await response.stream.bytesToString());
        return {
          "complaints": complaints['complaints'],
          "count": complaints["complaintsCount"]
        };
      } else if (response.statusCode == 404) {
        return await response.stream.bytesToString();
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }

  /// get request by id
  Future<dynamic> getComplaint(String token, int id) async {
    await init();
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.Request('GET', Uri.parse('$baseUrl/client/complaints/$id'));

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }

  ///get image
  Future<dynamic> getImage(String token, String name) async {
    await init();
    var headers = {'Authorization': 'Bearer $token'};

    try {
      var response = await http.get(Uri.parse('$baseUrl/client/images/$name'),
          headers: headers);

      if (response.statusCode == 200) {
        return (response.bodyBytes);
      } else {
        throw (response.bodyBytes);
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
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

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 202) {
        return (await response.stream.bytesToString());
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }

  Future<dynamic> postFeedback(
      String token, String type, String feedback) async {
    await init();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$baseUrl/client/feedback'));
    request.body = '''{"feedback":"$feedback","feedback_type":"$type"}''';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        return (await response.stream.bytesToString());
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }

  Future<dynamic> deleteRequest(String token, int id) async {
    await init();
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.Request('DELETE', Uri.parse('$baseUrl/client/complaints/$id'));

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return (await response.stream.bytesToString());
      } else {
        throw (await response.stream.bytesToString());
      }
    } on SocketException {
      throw ('server error');
    } catch (e) {
      throw (e);
    }
  }
}
