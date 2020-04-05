
import 'package:flutter/material.dart';
import 'package:memnder/application/view/shared/swipeable/content_card.dart';
import 'package:memnder/application/view/shared/swipeable/draggable_card.dart';
import 'package:memnder/application/view/shared/swipeable/image_preloader.dart';

class SwipeableCard extends StatefulWidget {

  final List<PreloadedImage> images;
  final void Function(SlideDirection) onSlide;
  final void Function(int) indexChanged;
  final int initialIndex;

  SwipeableCard({
    Key key,
    @required this.images,
    this.onSlide,
    this.indexChanged,
    this.initialIndex = 0
  }) : super(key: key);

  @override
  _SwipeableCardState createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> {

  ValueNotifier<List<PreslideInfo>> _preSlide = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return DraggableCard(
      onSlide: widget.onSlide,
      preSlide: (s){
        _preSlide.value = s;
        _preSlide.notifyListeners();
      },
      card: ValueListenableBuilder<List<PreslideInfo>>(
        valueListenable: _preSlide,
        builder: (context, value, child){
          return ContentCard(
            images: widget.images,
            preslideInfos: value,
            indexChanged: widget.indexChanged,
            initialIndex: widget.initialIndex,
          );
        },
      ),
    );
  }
}