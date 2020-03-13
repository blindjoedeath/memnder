import 'package:flutter/material.dart';

class MemeModel{
  final int id;
  final List<String> images;

  const MemeModel(
    {
      @required this.id,
      @required this.images
    }
  );
}