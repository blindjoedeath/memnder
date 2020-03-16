import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MemeDetail extends StatefulWidget{

  final List<String> images;
  final int initialPage;

  const MemeDetail(
    {
      @required this.images,
      this.initialPage = 0
    }
  );

  @override
  State<StatefulWidget> createState() => _MemeDetailState();

}

class _MemeDetailState extends State<MemeDetail>{

  PageController _controller;
  ValueNotifier<bool> _isWithAppBar = ValueNotifier(false);
  int _currentIndex;

  @override
  void initState(){
    super.initState();
    _currentIndex = widget.initialPage;
    _controller = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  Widget _buildBody(){
    return GestureDetector(
      child: PhotoViewGallery.builder(
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.images[index]),
            initialScale: PhotoViewComputedScale.contained,
            filterQuality: FilterQuality.high,
            maxScale: PhotoViewComputedScale.contained * 2,
            minScale: PhotoViewComputedScale.contained,
            basePosition: Alignment.center
          );
        },    
        onPageChanged: (i) => _currentIndex = i,
        pageController: _controller,
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
      ),
      onTap: (){
        _isWithAppBar.value = !_isWithAppBar.value;
        _isWithAppBar.notifyListeners();
        _controller.dispose();
        _controller = PageController(initialPage: _currentIndex);
      },
    );
  }

  Widget _buildCloseButton(){
    return ValueListenableBuilder(
      valueListenable: _isWithAppBar,
      builder: (context, state, child){
        if (state){
          return SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.close, color: Colors.white, size: 32,),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                )
              ],
            )
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildBody(),
        _buildCloseButton(),
      ],
    );
  }

}