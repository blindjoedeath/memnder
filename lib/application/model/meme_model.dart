import 'package:flutter/material.dart';

class MemeModel{
  final int id;
  final String imageLink;

  const MemeModel(
    {
      @required this.id,
      @required this.imageLink
    }
  );
}