import 'dart:convert';

class LoginResponseModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String jwtToken;

  LoginResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.jwtToken,
  });

  factory LoginResponseModel.fromRawJson(String str) =>
      LoginResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        jwtToken: json["jwt-token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "jwt-token": jwtToken,
      };
}
