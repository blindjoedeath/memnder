import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memnder/application/view/shared/swipeable/draggable_card.dart';
import 'package:memnder/application/view/shared/swipeable/image_preloader.dart';

class PhotoBrowser extends StatefulWidget {
  final List<PreloadedImage> images;
  final int visiblePhotoIndex;
  final Function(int) indexChanged;
  final Function(EmptyRotationSide side) emptyPhotoChangeAttempt;
  final Function() tapUp;
  final double indicatorOpacity;
  final Size size;

  PhotoBrowser(
    {
      @required this.images,
      this.visiblePhotoIndex = 0,
      this.indexChanged,
      this.emptyPhotoChangeAttempt,
      this.tapUp,
      this.indicatorOpacity = 1,
      this.size,
    }
  );

  @override
  _PhotoBrowserState createState() => _PhotoBrowserState();
}

class _PhotoBrowserState extends State<PhotoBrowser> {
  int visiblePhotoIndex;

  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = widget.visiblePhotoIndex;
  }

  @override
  void didUpdateWidget(PhotoBrowser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visiblePhotoIndex != oldWidget.visiblePhotoIndex) {
      setState(() {
        visiblePhotoIndex = widget.visiblePhotoIndex;
      });
    }
  }

  void _indexChanged(){
    if (widget.indexChanged != null){
      widget.indexChanged(visiblePhotoIndex);
    }
  }

  void _emptyPhotoChangeAttempt(EmptyRotationSide side){
    if (widget.emptyPhotoChangeAttempt != null){
      widget.emptyPhotoChangeAttempt(side);
    }
  }

  int _indexDelta = 0;
  void _tapUp(bool withIndexChange){
    if (widget.tapUp != null){
      widget.tapUp();
    }
    if (withIndexChange){
      setState(() {
        visiblePhotoIndex += _indexDelta;
        _indexChanged();
      });
    }
  }
  
  void _prevImage() {
    if (visiblePhotoIndex > 0){
      _indexDelta = -1;
    } else{
      _indexDelta = 0;
      _emptyPhotoChangeAttempt(EmptyRotationSide.left);
    }
  }

  void _nextImage() {
    if (visiblePhotoIndex < widget.images.length - 1){
      _indexDelta = 1;
    } else{
      _indexDelta = 0;
      _emptyPhotoChangeAttempt(EmptyRotationSide.right);
    }
  }

  Widget _buildPhotoControls() {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new GestureDetector(
          onTapDown: (d) => _prevImage(),
          onTapUp: (d) => _tapUp(true),
          onTapCancel: () => _tapUp(false),
          child: new FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: new Container(
              color: Colors.transparent,
            ),
          ),
        ),
        new GestureDetector(
          onTapDown: (d) => _nextImage(),
          onTapUp: (d) => _tapUp(true),
          onTapCancel: () => _tapUp(false),
          child: new FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topRight,
            child: new Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(){
    return Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        child: SelectedPhotoIndicator(
          photoCount: widget.images.length,
          visiblePhotoIndex: visiblePhotoIndex,
          opacity: widget.images.length == 1 ? 0.0 : widget.indicatorOpacity,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width;
    var height;
    if(widget.images[visiblePhotoIndex].size.aspectRatio > 1){
      height = widget.size.width * widget.images[visiblePhotoIndex].size.flipped.aspectRatio;
    } else{
      width = widget.size.height * widget.images[visiblePhotoIndex].size.aspectRatio;
    }

    return Stack(
      children: <Widget>[
        new Hero(
          tag: "swipeHero$visiblePhotoIndex",
          child: Container(
            alignment: Alignment.center,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: widget.images[visiblePhotoIndex].imageProvider,
                  fit: BoxFit.contain,
                )
              ),
            ),
          )
        ),
        _buildIndicator(),
        _buildPhotoControls(),
      ],
    );
  }
}

class SelectedPhotoIndicator extends StatelessWidget {
  final int photoCount;
  final int visiblePhotoIndex;
  final double opacity;

  SelectedPhotoIndicator({this.visiblePhotoIndex, this.photoCount, this.opacity = 1});

  Widget _buildInactiveIndicator() {
    return new Expanded(
      child: new Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: new Container(
          height: 3.0,
          decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: new BorderRadius.circular(2.5)),
        ),
      ),
    );
  }

  Widget _buildActiveIndicator() {
    return new Expanded(
      child: new Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: new Container(
          height: 3.0,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(2.5),
              boxShadow: [
                new BoxShadow(
                    color: const Color(0x22000000),
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: const Offset(0.0, 1.0))
              ]),
        ),
      ),
    );
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < photoCount; i++) {
      indicators.add(i == visiblePhotoIndex
          ? _buildActiveIndicator()
          : _buildInactiveIndicator());
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      child: Opacity(
        opacity: opacity,
        child: Row(
          children: _buildIndicators(),
        ),
      ),
    );
  }
}
