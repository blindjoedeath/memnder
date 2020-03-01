import 'package:flutter/material.dart';

class RecomededMemeApiModel{
  final int id;
  final List<String> images;
  final int likes;
  final int dislikes;

  const RecomededMemeApiModel(
    {
      @required this.id,
      @required this.images,
      @required this.likes,
      @required this.dislikes
    }
  );

  factory RecomededMemeApiModel.fromJson(Map<String, dynamic> json){

    return RecomededMemeApiModel(
      id: json["id"],
      images: (json["images"] as List).cast<String>(),
      likes: json["likes"],
      dislikes: json["dislikes"]
    );
  }

  RecomededMemeApiModel copyWith({int id, int likes, int dislikes, List<String> images}){
    return RecomededMemeApiModel(
      id: id ?? this.id,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      images: images ?? this.images
    );
  }
}