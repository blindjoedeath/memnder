import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_dart2/layout.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

enum EmptyRotationSide {
  left,
  right,
}

enum SlideDirection {
  left,
  right,
  down,
}

class DraggableCard extends StatefulWidget {
  final Widget card;
  final DraggableCardController controller;
  final Function(SlideDirection direction) onSlide;
  final Function(List<PreslideInfo>) preSlide;

  DraggableCard({
    Key key,
    @required this.card,
    this.controller,
    this.onSlide,
    this.preSlide
  });

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class DraggableCardController extends PropertyChangeNotifier{

  SlideDirection _currentSlideToDirection;

  void slideTo(SlideDirection direction){
    _currentSlideToDirection = direction;
    notifyListeners("direction");
  } 

}

class _DraggableCardState extends State<DraggableCard> with TickerProviderStateMixin {
  GlobalKey profileCardKey = GlobalKey(debugLabel: 'profile_card_key');
  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;
  Offset slideBackStart;
  SlideDirection slideOutDirection;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;

  void _onSlide(){
    if (widget.onSlide != null) {
      widget.onSlide(slideOutDirection);
    }
  }

  final double _minPreslideHorPercent = 0.1;
  final double _minPreslideVertPercent = 0.1;

  void _updatePreslideInfo({bool isBackAnimation = false}){
    if (widget.preSlide != null) {
      if(isBackAnimation){
        widget.preSlide(null);
        return;
      }

      var percentX = cardOffset.dx / context.size.width;
      var percentY = cardOffset.dy / context.size.height;

      List<PreslideInfo> infos = List<PreslideInfo>();

      var direction = percentX > 0 ? SlideDirection.right : SlideDirection.left;
      percentX = percentX.abs() - _minPreslideHorPercent;
      percentX /= _horNoSlideRegionHalfSpace - _minPreslideHorPercent;
      percentX = percentX.clamp(0.0, 1.0);
      infos.add(PreslideInfo(direction: direction, percent: percentX));

      if (percentY >= 0){
        percentY = percentY.abs() - _minPreslideVertPercent;
        percentY /= _vertNoSlideRegionHalfSpace - _minPreslideVertPercent;
        percentY = percentY.clamp(0.0, 1.0);
        percentY *= pow(1-percentX, 2);
      } else{
        percentY = 0.0;
      }
      infos.add(PreslideInfo(direction: SlideDirection.down, percent: percentY));
      widget.preSlide(infos);
    }
  }

  void _slideDirectionListener(){
    var direction = widget.controller._currentSlideToDirection;
    if (direction == SlideDirection.left){
      _slideLeft();
    } else if (direction == SlideDirection.right){
      _slideRight();
    }
  }

  @override
  void initState() {
    super.initState();
    slideBackAnimation =  AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addListener(() => setState(() {
        _updatePreslideInfo(isBackAnimation: true);
          cardOffset = Offset.lerp(slideBackStart, const Offset(0.0, 0.0),
                Curves.elasticOut.transform(slideBackAnimation.value));
        }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
        } else if(status == AnimationStatus.forward && slideOutDirection == SlideDirection.down){
          _onSlide();
        }
      });

    slideOutAnimation =  AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )
      ..addListener(() => setState(() {
            cardOffset = slideOutTween.evaluate(slideOutAnimation);
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          dragStart = null;
          dragPosition = null;
          slideOutTween = null;

          _onSlide();
        }
      });

    widget.controller?.addListener(_slideDirectionListener, ["direction"]);
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.key != oldWidget.card.key) {
      cardOffset = const Offset(0.0, 0.0);
    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    slideOutAnimation.dispose();
    widget.controller?.removeListener(_slideDirectionListener, ["direction"]);
    super.dispose();
  }

  void _slideLeft() {
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(-2 * MediaQuery.of(context).size.width, 0.0),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  Offset _chooseRandomDragStart() {
    final cardContex = profileCardKey.currentContext;
    final cardTopLeft = (cardContex.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0));
    final dragStartY =
        MediaQuery.of(context).size.height * ( Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
            cardTopLeft.dy;

    return Offset(MediaQuery.of(context).size.width / 2 + cardTopLeft.dx, dragStartY);
  }

  void _slideRight() {
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(2 * MediaQuery.of(context).size.width, 0.0),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;
    slideOutDirection = null;
    
    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updatePreslideInfo();
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;
    });
  }

  final double _horNoSlideRegionHalfSpace = 0.3;
  final double _vertNoSlideRegionHalfSpace = 0.3;
  final double _minFlingVelocity = 800;

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInLeftRegion = (cardOffset.dx / context.size.width) < -_horNoSlideRegionHalfSpace;
    final isInRightRegion = (cardOffset.dx / context.size.width) > _horNoSlideRegionHalfSpace;
    final isInBottomRegion = (cardOffset.dy / context.size.height) > _vertNoSlideRegionHalfSpace;
    final isFling = details.velocity.pixelsPerSecond.dy > _minFlingVelocity;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideOutTween =  Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));

        slideOutAnimation.forward(from: 0.0);

        slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;
      } else {
        if ((isInBottomRegion && !(isInLeftRegion || isInRightRegion)) || isFling){
          slideOutDirection = SlideDirection.down;
        }
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 12) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return const Offset(0.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    var size = MediaQuery.of(context).size;
    var anchorBounds = Rect.fromLTWH(0, padding.top, size.width, size.height);
    return Transform(
      transform:
          Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
            ..rotateZ(_rotation(anchorBounds)),
      origin: _rotationOrigin(anchorBounds),
      child: Container(
        key: profileCardKey,
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: widget.card,
        ),
      ),
    );
  }
}

class PreslideInfo{
  final SlideDirection direction;
  final double percent;

  const PreslideInfo(
    {
      @required this.direction,
      @required this.percent
    }
  );
}