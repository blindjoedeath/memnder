
import 'dart:convert';
import 'package:memnder/application/entity/codable/codable.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SecureStorageKey{
  jwtCredentials
}

abstract class SecureStorageProviderInterface{
  Future<bool> save<T extends Encodable>(SecureStorageKey key, T value);
  Future<T> load<T extends Decodable>(SecureStorageKey key, T value);
}

class SecureStorageProvider extends SecureStorageProviderInterface{

  @override
  Future<bool> save<T extends Encodable>(SecureStorageKey key, T value)async{
    
    var instance = await SharedPreferences.getInstance();
    
    if(value == null){
      return await instance.setString("$key", null);
    }

    var map = Map<String, dynamic>();
    value.encodeToJson(map);
    var json = jsonEncode(map);

    await instance.setString("$key", json);
  }

  @override
  Future<T> load<T extends Decodable>(SecureStorageKey key, T value)async{
    var instance = await SharedPreferences.getInstance();
    var json = instance.getString("$key");
    if (json == null){
      return null;
    }
    var map = jsonDecode(json);
    value.decodeFrom(map);

    print("LOADED $value");

    return value;
  }
}

