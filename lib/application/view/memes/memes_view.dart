

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:memnder/application/bloc/memes/memes_event.dart';
import 'package:memnder/application/bloc/memes/memes_state.dart';
import 'package:memnder/application/entity/meme_reaction.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:memnder/application/view/shared/animation/fly_animation.dart';
import 'package:memnder/application/view/shared/screen/meme_detail.dart';

class MemesView extends StatefulWidget{

  final Bloc<MemesEvent, MemesState> bloc;

  const MemesView({@required this.bloc});

  @override
  State<StatefulWidget> createState() => _MemesViewState();
  
}

class _MemesViewState extends State<MemesView> with SingleTickerProviderStateMixin{

  MemeModel meme;
  FlyAnimationController _flyController;
  ValueNotifier<bool> _imageFullyLoaded = ValueNotifier(false);
  int _currentImage = 0;

  void _setImageLoaded(bool state){
    if (state){
      WidgetsBinding.instance.addPostFrameCallback((r){
        _imageFullyLoaded.value = state;
        _imageFullyLoaded.notifyListeners();
      });
    } else{
      _imageFullyLoaded.value = state;
      _imageFullyLoaded.notifyListeners();
    }
  }

  @override
  void initState(){
    super.initState();
    _flyController = FlyAnimationController(
      vsync: this
    );
  }

  @override
  void dispose(){
    super.dispose();
    _flyController.dispose();
  }

  void _resetState(){
    _currentImage = 0;
    _setImageLoaded(false);
  }

  void _setReaction(MemeReaction reaction)async{
    _resetState();
    _flyController.direction = FlyAnimationDirection.left;
    if (reaction == MemeReaction.like){
      _flyController.direction = FlyAnimationDirection.right;
    }
    var animation = _flyController.forward();

    widget.bloc.add(MemeReactionSet(
      meme: meme,
      reaction: reaction
    ));
    await animation;
    _flyController.reset();
    setState(() {});
  }

  Widget _buildFloatingRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FloatingActionButton.extended(
          onPressed: () => _setReaction(MemeReaction.skip),
          label: Text('Пропустить'),
          icon: Icon(Icons.navigate_next),
          backgroundColor: Colors.black45,
          heroTag: null,
        ),
        FloatingActionButton.extended(
          onPressed: () => _setReaction(MemeReaction.like),
          label: Text('     Лайк     '),
          icon: Icon(Icons.thumb_up),
          backgroundColor: Colors.green,
          heroTag: null,
        ),
      ],
    );
  }

  Widget _buildImage(String link){
    return TransitionToImage(
      fit: BoxFit.fitWidth,
      image: AdvancedNetworkImage(
        link,
      ),
      placeholder: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.green),
      ),
      loadedCallback: (){
        _setImageLoaded(true);
      },
    );
  }

  Widget _buildSwiper(MemeModel meme){
    return Swiper(
      itemCount: meme.images.length,
      itemBuilder: (context, index){
        return _buildImage(meme.images[index]);
      },
      onIndexChanged: (i) => _currentImage = i,
      loop: false,
      pagination: SwiperPagination(
        margin: EdgeInsets.all(5),
        builder: DotSwiperPaginationBuilder(
          color: Colors.grey,
          activeColor: Colors.blue,
        )
      ),
    );
  }

  void _showDetail(MemeModel meme){
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context){
          return MemeDetail(
            images: meme.images,
            initialPage: _currentImage,
          );
        },
        fullscreenDialog: true
      )
    );
  }

  Widget _buildMeme(MemeModel meme){
    return GestureDetector(
      child: FlyAnimation(
        controller: _flyController,
        child: meme.images.length > 1 ? _buildSwiper(meme) 
                                      : _buildImage(meme.images[0])
      ),
      onTapUp: (d){
        _showDetail(meme);
      },
    );
  }

  Widget _buildText(String text){
    return Text(text, 
      style: Theme.of(context).textTheme.display1,
    ); 
  }

  Widget _buildBody(MemesState state){
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 24, right: 12, left: 12, bottom: 88),
        child:  (state is ShowMeme ? _buildMeme(state.meme) : 
                (state is Loading && _flyController.isAnimating) ? _buildMeme(meme) : 
                (state is Loading) ? CircularProgressIndicator() : 
                (state is Unauthenticated ? _buildText("Авторизуйтесь") : 
                (state is ShowAlert ? _buildText(state.message) : null))),
      )
    );
  }

  void requestMeme(){
    widget.bloc.add(MemeRequested());
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

  void showAlert(String message){
    WidgetsBinding.instance.addPostFrameCallback((d){
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(message)
        )
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc<MemesEvent, MemesState>, MemesState>(
        bloc: widget.bloc,
        builder: (context, state){
          if (state is Initial){
            requestMeme();
          } else if (state is ShowMeme){
            meme = state.meme;
          } else if(state is ShowError){
            showError(state.message);
          }
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: const Text('Мемы'),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: state is ShowMeme ? ValueListenableBuilder<bool>(
                valueListenable: _imageFullyLoaded,
                builder: (context, state, child){
                  if (state){
                    return _buildFloatingRow();
                  }
                  return Container();
                },) : null,
            body: _buildBody(state),
          );
        }
    );
  }

}