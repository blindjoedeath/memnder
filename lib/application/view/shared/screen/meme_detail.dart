import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MemeDetail extends StatefulWidget{

  final List<String> images;

  const MemeDetail(
    {
      @required this.images
    }
  );

  @override
  State<StatefulWidget> createState() => _MemeDetailState();

}

class _MemeDetailState extends State<MemeDetail>{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoViewGallery.builder(
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.images[index]),
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: widget.images[index]),
            filterQuality: FilterQuality.high,
            maxScale: PhotoViewComputedScale.contained * 2,
            minScale: PhotoViewComputedScale.contained,
          );
        },    
        itemCount: widget.images.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        backgroundDecoration: BoxDecoration(
          color: Colors.black
        ),
      )
    );
  }

}