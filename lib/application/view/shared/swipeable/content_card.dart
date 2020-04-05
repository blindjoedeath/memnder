import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:memnder/application/view/shared/swipeable/draggable_card.dart';
import 'package:memnder/application/view/shared/swipeable/image_preloader.dart';
import 'package:memnder/application/view/shared/swipeable/photo_browser.dart';

class ContentCard extends StatefulWidget {
  final List<PreloadedImage> images;
  final List<PreslideInfo> preslideInfos;
  final Function(int) indexChanged;
  final int initialIndex;

  ContentCard(
    {
      Key key,
      @required this.images,
      this.preslideInfos,
      this.indexChanged,
      this.initialIndex = 0
    }
  ) : super(key: key);

  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> with SingleTickerProviderStateMixin{

  AnimationController _emptyRotationController;
  Animation<double> _emptyRotation;

  @override
  void initState() { 
    super.initState();
    _emptyRotationController = AnimationController(vsync: this, duration: Duration(milliseconds: 50));
    _emptyRotation = Tween<double>(begin: 0.0, end: 0.0).animate(_emptyRotationController);
  }

  @override
  void dispose() { 
    _emptyRotationController.dispose();
    super.dispose();
  }

  double get cardPadding{ 
    return 4;
  }

  double get cardWidth{ 
    return MediaQuery.of(context).size.width - 2 * cardPadding;
  }

  double get cardHeight{ 
    return cardWidth * (4/3);
  }

  double get innerMargins{ 
    return 6;
  }

    Widget _buildBackground() {
    return PhotoBrowser(
      images: widget.images,
      visiblePhotoIndex: widget.initialIndex,
      emptyPhotoChangeAttempt: _emptyPhotoChangeAttempt,
      tapUp: _tapUp,
      size: Size(cardWidth - 2*innerMargins, cardHeight - 3 * innerMargins),
      indexChanged: widget.indexChanged,
      indicatorOpacity: _indicatorOpacity,
    );
  }

  TickerFuture _animation;
  void _tapUp()async{
    _animation.whenComplete(() => _emptyRotationController.reverse());
  }

  void _emptyPhotoChangeAttempt(EmptyRotationSide side){
    var sign = side == EmptyRotationSide.left ? 1: -1;
    _emptyRotation = Tween<double>(
      begin: 0.0,
      end: sign * (pi / 20)
    )
    .animate(
    CurvedAnimation(
      curve: Curves.linear,
      parent: _emptyRotationController
    ))
    ..addListener(() => setState((){}));
    setState(() {
      _animation = _emptyRotationController.forward();
    });
  }

  Widget _buildPreSlideInfo(){
    var infos = widget.preslideInfos;
    if (infos == null){
      return Container();
    }
    return Stack(
      fit: StackFit.expand,
      children: infos.map((info){
        var percent = pow(info.percent, 1.5);
        var alignment, color, icon;
        if (info.direction == SlideDirection.left){
          alignment = Alignment.topRight;
          color = Colors.red;
          icon = Icons.thumb_down;
        } else if (info.direction == SlideDirection.right){
          alignment = Alignment.topLeft;
          color = Colors.green;
          icon = Icons.thumb_up;
        } else{
          alignment = Alignment.topCenter;
          color = Colors.blueGrey;
          icon = Icons.open_in_browser;
        }
        return Container(
          padding: EdgeInsets.only(top: 12, left: 16, right: 16),
          alignment: alignment,
          child: Icon(icon,
            color: color.withOpacity(percent),
            size: 32 + info.percent * 14
          )
        );
      }
      ).toList(),
    );
  }

  Widget _buildContent(){
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _buildBackground(),
        _buildPreSlideInfo()
      ],
    );
  }

  Color _shadowColor;
  double _indicatorOpacity = 1;
  void _updateCommonPreslideInfo(){
    if (widget.preslideInfos != null){
      var info = widget.preslideInfos?.firstWhere((element) => element.direction != SlideDirection.down);
      _shadowColor = Color.lerp(Colors.black,
                                (info.direction == SlideDirection.left ? Colors.red : Colors.green),
                                pow(info.percent, 0.1));
      _indicatorOpacity = 1 - widget.preslideInfos.map((e) => e.percent).reduce((value, element) => value+element);
    } else{
      _shadowColor = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateCommonPreslideInfo();

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_emptyRotation.value),
      child: Container(
        margin: EdgeInsets.all(cardPadding),
        height: cardHeight,
        width: cardWidth,
        child: Material(
          borderRadius: BorderRadius.circular(4),
          elevation: 4,
          shadowColor: _shadowColor,
          child: Container(
            margin: EdgeInsets.only(bottom: 2*innerMargins,
                                    top: innerMargins,
                                    right: innerMargins,
                                    left: innerMargins),
            child: _buildContent(),
          ),
        )
      )
    );
  }
}
