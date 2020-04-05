
import 'dart:async';

import 'package:flutter/material.dart';


class PreloadedImage{
  final Size size;
  final ImageProvider imageProvider;

  const PreloadedImage(
    {
      @required this.size,
      @required this.imageProvider
    }
  );
  
}

class ImagePreloader{
  
  static Future<List<PreloadedImage>> preload(List<String> images){
    var futures = images.map((e)async{
      var image = NetworkImage(e);
      var completer = Completer<Size>();
      image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo image, bool synchronousCall) async{
            var myImage = image.image;
            Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
            completer.complete(size);
          },
        ),
      );
      var size = await completer.future;
      return PreloadedImage(imageProvider: image, size: size);
    });
    return Future.wait(futures);
  }
}