class User {
  String name;
  String email;
  String token;

  User({this.name, this.email, this.token});

  factory User.fromJson(Map<String, dynamic> json, token){
    return User(
      email: json['email'],
      name: json['name'],
      token: token,
      );
  }
}
