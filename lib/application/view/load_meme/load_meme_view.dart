import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/load_meme/load_meme_event.dart';
import 'package:memnder/application/bloc/load_meme/load_meme_state.dart';
import 'package:memnder/application/view/load_meme/load_meme_grid.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class LoadMemeView extends StatefulWidget{

  final Bloc<LoadMemeEvent, LoadMemeState> bloc;

  const LoadMemeView(
    {
      @required this.bloc
    }
  );

  @override
  State<StatefulWidget> createState() => _LoadMemeViewState();

}

class _LoadMemeViewState extends State<LoadMemeView>{

  List<Asset> _images = List<Asset>();
  final int kMaxCount = 5;

  ValueNotifier<bool> _isEdit = ValueNotifier(false);

  void _loadImages()async{
    try {
      var picked = await MultiImagePicker.pickImages(
        maxImages: kMaxCount - _images.length,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      _images.addAll(picked);
      setState(() {});
    } on NoImagesSelectedException catch(e){
      
    } on Exception catch (e) {
      var error = e.toString();
      _showError(error);
    }
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _showError(String message){
    WidgetsBinding.instance.addPostFrameCallback((d){
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Ошибка" + (message != null ? ": $message" : ""))
        )
      );
    });
  }

  void _showSuccess(){
    WidgetsBinding.instance.addPostFrameCallback((d){
      EasyLoading.showSuccess('Успешно!');
      Future.delayed(Duration(seconds: 2), (){
        EasyLoading.dismiss();
        widget.bloc.add(ShowedAlert());
        Navigator.pop(context);
      }); 
    }); 
  }

  void _showSending(){
    WidgetsBinding.instance.addPostFrameCallback((d){
      EasyLoading.show(status: 'Отправляем...');
      Future.delayed(Duration(seconds: 2), (){
        EasyLoading.dismiss();
        widget.bloc.add(ShowedAlert());
      }); 
    }); 
  }

  void _showLoadingError(){
    WidgetsBinding.instance.addPostFrameCallback((d){
      EasyLoading.showError('Ошибка!');
      Future.delayed(Duration(seconds: 2), (){
        EasyLoading.dismiss();
        widget.bloc.add(ShowedAlert());
      }); 
    });
  }

  Widget _buildGridView() {
    return LoadMemeGrid(
      isEdit: _isEdit,
      images: _images,
      listChanged: (assets){
        setState(() {
          _images = assets;
        });
      },
    );
  }

  Widget _buildAppBar(){

    var actions = List<Widget>();
    if (_images.isNotEmpty){
      actions.add(
        IconButton(
          icon: Icon(_isEdit.value ? Icons.done : Icons.edit),
          onPressed: (){
            setState(() {
              _isEdit.value = !_isEdit.value;
              _isEdit.notifyListeners();
            });
          }
        )
      );
    }

    return AppBar(title:
      Text("Загрузка мема"),
      actions: actions
    );
  }

  Widget _buildBody(){
    return BlocBuilder<Bloc<LoadMemeEvent, LoadMemeState>, LoadMemeState>(
      bloc: widget.bloc,
      builder: (context, state){
        
        if (state is LoadError){
          _showLoadingError();
        } else if (state is LoadSuccess){
          _showSuccess();
        } if (state is Sending){
          _showSending();
        }

        return _images.isEmpty ? Center(
          child: Text(
            "Загрузите мемы",
            style: Theme.of(context).textTheme.display1.copyWith(fontSize: 32)
          ) 
        ) : _buildGridView();
      },
    );
  }

  void _sendMemes()async{
    var sendImages = List<List<int>>();
    for(int i = 0; i < _images.length; ++i){
      var byteData = await _images[i].getByteData();
      var image = byteData.buffer.asUint8List();
      sendImages.add(image);
    }
    widget.bloc.add(SendMeme(
      images: sendImages
    ));
  }

  Widget _buildFloatingButton(){
    return ValueListenableBuilder(
      valueListenable: _isEdit,
      builder: (context, state, child){
        return FloatingActionButton(
          child: Icon((state && _images.length < kMaxCount || _images.isEmpty) ? Icons.add : Icons.send),
          onPressed: (){
            if (state && _images.length < kMaxCount || _images.isEmpty){
              _loadImages();
            } else{
              _sendMemes();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingButton(),
    );
  }

}
			