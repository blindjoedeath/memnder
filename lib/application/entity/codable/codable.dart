

abstract class Encodable{
  void encodeToJson(Map<String, dynamic> json);
}

abstract class Decodable{
  void decodeFrom(Map<String, dynamic> json);
}

abstract class Codable implements Encodable, Decodable{}