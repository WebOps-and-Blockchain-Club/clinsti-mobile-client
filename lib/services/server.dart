import 'dart:convert';
import 'package:http/http.dart' as http;

class Server {
  final String link =
      "http://192.168.42.136:3000"; //TODO: put your local netwok config here

  ////Account Requests
  ///SignUp
  Future<dynamic> signUp(String email, String password, String name) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('$link/api/signup'));
    request.body =
        '{"name": "$name","email": "$email","password": "$password"}';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw (response.reasonPhrase);
    }
  }

  ///SignIn
  Future<dynamic> signIn(String email, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('$link/api/signin'));
    request.body = '{"email": "$email",   "password": "$password"}';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw (response.reasonPhrase);
    }
  }

  //View Profile
  Future<dynamic> getUserInfo(String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse('$link/api/user/me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw (response.reasonPhrase);
    }
  }

  ///Edit Profile
  Future<dynamic> updateProfile(String token,
      {String name, String email}) async {
    if (name == null && email == null) {
      return;
    }
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('PATCH', Uri.parse('http://$link/api/editprofile'));
    if (name == null) {
      request.body = '{"email":"$email"}';
    } else if (email == null) {
      request.body = '{"name":"$name"';
    } else {
      request.body = '{"name":"$name","email":"$email"}';
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw (response.reasonPhrase);
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
        http.Request('POST', Uri.parse('http://$link/api/changePassword'));
    request.body = '{"oldPassword": "$oldPass","newPassword":"$newPass"}';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw (response.reasonPhrase);
    }
  }

  ////Complaints Requests
}
