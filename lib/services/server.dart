import 'dart:convert';
import 'package:app_client/models/user.dart';
import 'package:http/http.dart' as http;

class Server {
  final String baseUrl =
      "http://192.168.101.13:3000"; //TODO: put your local netwok config here
  final String signup = "/client/accounts/signup";
  final String signin = '/client/accounts/signin';

  ////Account Requests
  ///SignUp
  Future<dynamic> signUp(String email, String password, String name) async {
    var headers = {'Content-Type': 'application/json'};
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
    var headers = {'Content-Type': 'application/json'};
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
      var convertedData = jsonDecode(await response.stream.bytesToString());
      User user = User.fromJson(convertedData, token);
      return user;
    } else {
      throw (response);
    }
  }

  ///Change Password
  Future<dynamic> changePassword(
      String token, String oldPass, String newPass) async {
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
}
