class User {
  String name;
  String email;
  String token;
  bool? isVerified;

  User(
      {required this.name,
      required this.email,
      this.isVerified,
      required this.token});

  factory User.fromJson(Map<String, dynamic> json, token) {
    return User(
      email: json['email'],
      name: json['name'],
      isVerified: json['isVerified'],
      token: token,
    );
  }
}
