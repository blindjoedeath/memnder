

import 'package:flutter/material.dart';
import 'package:memnder/application/api_model/meme_api_model.dart';

class UserMemesApiModel{
  final int count;
  final String next;
  final String previous;
  final List<MemeApiModel> memes;

  const UserMemesApiModel(
    {
      @required this.count,
      @required this.next,
      @required this.previous,
      @required this.memes
    }
  );

  factory UserMemesApiModel.fromJson(Map<String, dynamic> json) {
    return UserMemesApiModel(
      count: json['count'],
      next: json["next"],
      previous: json["previous"],
      memes: (json["results"] as List).map((r) => MemeApiModel.fromJson(r)).toList()
    );
  }

}