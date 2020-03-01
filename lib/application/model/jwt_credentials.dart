

import 'package:memnder/application/entity/codable/codable.dart';

class JwtCredentials extends Codable{
  String username;
  String password;
  String accessToken;
  String refreshToken;

  JwtCredentials(
    {
      this.username,
      this.password,
      this.accessToken,
      this.refreshToken
    }
  );

  @override
  void encodeToJson(Map<String, dynamic> json) {
    json["username"] = username;
    json["password"] = password;
    json["accessToken"] = accessToken;
    json["refreshToken"] = refreshToken;
  }

  void decodeFrom(Map<String, dynamic> json){
    username = json["username"];
    password = json["password"];
    accessToken = json["accessToken"];
    refreshToken = json["refreshToken"];
  }

}