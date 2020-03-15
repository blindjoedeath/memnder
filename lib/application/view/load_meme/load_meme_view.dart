import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/load_meme/load_meme_event.dart';
import 'package:memnder/application/bloc/load_meme/load_meme_state.dart';
import 'package:memnder/application/view/load_meme/load_meme_grid.dart';
import 'package:memnder/application/view/shared/button/sign_button.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


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
      showError(error);
    }
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void showError(String message){
    WidgetsBinding.instance.addPostFrameCallback((d){
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Ошибка" + (message != null ? ": $message" : ""))
        )
      );
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
    return _images.isEmpty ? Center(
      child: Text(
        "Загрузите мемы",
        style: Theme.of(context).textTheme.display1,
      ) 
    ) : _buildGridView();
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
              // send
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
			