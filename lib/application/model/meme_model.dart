import 'package:flutter/material.dart';

class MemeModel{
  final int id;
  final int likes;
  final int dislikes;
  final int author;
  final List<String> images;

  const MemeModel(
    {
      @required this.id,
      @required this.likes,
      @required this.dislikes,
      this.author,
      @required this.images
    }
  );
}