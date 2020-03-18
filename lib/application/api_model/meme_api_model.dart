import 'package:flutter/material.dart';

class MemeApiModel{
  final int id;
  final List<String> images;
  final int likes;
  final int dislikes;
  final int author;

  const MemeApiModel(
    {
      @required this.id,
      @required this.images,
      @required this.likes,
      @required this.dislikes,
      @required this.author
    }
  );

  factory MemeApiModel.fromJson(Map<String, dynamic> json){

    return MemeApiModel(
      id: json["id"],
      images: (json["images"] as List).cast<String>(),
      likes: json["likes"],
      dislikes: json["dislikes"],
      author: json["author"]
    );
  }

  MemeApiModel copyWith({int id, int likes, int dislikes, int author, List<String> images}){
    return MemeApiModel(
      id: id ?? this.id,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      author: author ?? this.author,
      images: images ?? this.images
    );
  }
}