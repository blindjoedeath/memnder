

import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:reorderables/reorderables.dart';

class LoadMemeGrid extends StatefulWidget{

  final List<Asset> images;
  final Function(List<Asset>) listChanged;
  final ValueNotifier<bool> isEdit;

  const LoadMemeGrid(
    {
      @required this.images,
      @required this.listChanged,
      @required this.isEdit,
    }
  );

  @override
  State<StatefulWidget> createState() => _LoadMemeGridState();

}

class ItemInfo{
  final String id;
  final Widget widget;
  final Asset asset;

  const ItemInfo(
    {
      @required this.id,
      @required this.widget,
      @required this.asset
    }
  );
}

class _LoadMemeGridState extends State<LoadMemeGrid>{ 
  
  List<ItemInfo> _items = List<ItemInfo>();
  Future _imageLoading;

  double _kPaddingPercent = 0.04;

  double _itemSizeValue;
  double _itemSize(BuildContext context){
    if (_itemSizeValue == null){
      
      return _itemSizeValue = (MediaQuery.of(context).size.width / 3).truncateToDouble();
    }
    return _itemSizeValue;
  }
  
  Future<Widget> _getImageAt(int index, int size)async{
      var asset = widget.images[index];
      var bytes = await asset.getThumbByteData(size * 2, size * 2, quality: 100);
      var image = Image.memory(
        bytes.buffer.asUint8List(),
        filterQuality: FilterQuality.high,
      );
      return image;
  }

  Widget _buildEditIconButton(double size, String id){
    return Container(
      height: size,
      width: size,
      alignment: Alignment.topLeft,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black54,
        ),
        child: IconButton(
          iconSize: 28,
          padding: EdgeInsets.zero,
          icon: Icon(Icons.remove_circle_outline, color: Colors.white54),
          onPressed: (){
            var index = _items.indexWhere((i) => i.id == id);
            _onRemove(index);
          },
        ),
      )
    );
  }

  Widget _buildItemBase(double size, Widget image){
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all((size * _kPaddingPercent).roundToDouble()),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: image
      )
    );
  }

  Widget _buildItem(double size, Widget image, String id){

    var children = [_buildItemBase(size, image)];
    children.add(
      ValueListenableBuilder(
        valueListenable: widget.isEdit,
        builder: (context, state, child){
          if (state){
            return _buildEditIconButton(size, id);
          }
          return Container(
            height: size,
            width: size,
          );
        },
      )
    );

    return Stack(
      children: children
    );
  }

  Future _fillItems()async{
    _items = List<ItemInfo>();
    var size = _itemSize(context);
    var imageSize = (size * (1 - _kPaddingPercent*2)).round();
    for(var i = 0; i < widget.images.length; ++i){
      var image = await _getImageAt(i, imageSize);
      var id = i.toString();
      var item = _buildItem(size, image, id);
      var info = ItemInfo(
        id: id,
        widget: item,
        asset: widget.images[i]
      );

      _items.add(info);
    }
  }

  void _onRemove(int index) {
    setState(() {
      if (0 <= index && index < _items.length){
        _items.removeAt(index);
        widget.listChanged(_items.map((i) => i.asset).toList());
      }
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (0 <= newIndex && newIndex < _items.length){
        var item = _items[oldIndex];
        _items.removeAt(oldIndex);
        _items.insert(newIndex, item);
        widget.listChanged(_items.map((i) => i.asset).toList());
      }
    });
  }

  Widget _buildImagesGrid(){
    return ReorderableWrap(
      needsLongPressDraggable: false,
      children: _items.map((i) => i.widget).toList(),
      onReorder: _onReorder,
      buildDraggableFeedback: (context, constraints, item){
        return Transform.scale(
          scale: 1.15,
          child: Material(
            color: Colors.transparent,
            child: item,
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_imageLoading == null || _items.length != widget.images.length){
      _imageLoading = _fillItems();
    }
    return FutureBuilder(
      future: _imageLoading,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return _buildImagesGrid();
        }
        return Center(
          child: CircularProgressIndicator()
        );
      },
    );
  }

}