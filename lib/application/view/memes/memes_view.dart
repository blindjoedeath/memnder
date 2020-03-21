

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

  MemeModel savedMeme;
  FlyAnimationController _flyController;
  ValueNotifier<bool> _imageFullyLoaded = ValueNotifier(false);
  SwiperController _swiperController;
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
    _swiperController = SwiperController();

    if (widget.bloc.state is MemesEnded){
      _requestMeme();
    }
  }

  @override
  void dispose(){
    super.dispose();
    _flyController.dispose();
    _swiperController.dispose();
  }

  void _resetState(){
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
      meme: savedMeme,
      reaction: reaction
    ));
    await animation;
    setState(() {
      _swiperController.move(0, animation: false);
      _currentImage = 0;
    });
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
      fit: BoxFit.contain,
      image: AdvancedNetworkImage(
        link,
      ),
      placeholder: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.green),
      ),
      loadedCallback: (){
        _setImageLoaded(true);
        WidgetsBinding.instance.addPostFrameCallback((d){
          _flyController.reset();
        });
      },
    );
  }

  Widget _buildSwiper(MemeModel meme){
    return Swiper(
      controller: _swiperController,
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

  void _showDetail(MemeModel meme)async{
    int index = await Navigator.push(context,
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
    _currentImage = index;
    await _swiperController.move(_currentImage, animation: false);
  }

  Widget _buildMeme(MemeModel meme){
    if (meme.images.isEmpty){
      meme.images.add("https://www.ajactraining.org/wp-content/uploads/2019/09/image-placeholder.jpg");
      print("empty ${meme.id}");
    }

    return GestureDetector(
      child: FlyAnimation(
        controller: _flyController,
        child: SizedBox(
          width: double.infinity,
          height: 300,
          child: meme.images.length > 1 ? _buildSwiper(meme) 
                                      : _buildImage(meme.images[0])
        )
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
                (state is Loading && _flyController.isAnimating) ? _buildMeme(savedMeme) : 
                (state is Loading) ? CircularProgressIndicator() : 
                (state is Unauthenticated ? _buildText("Авторизуйтесь") : 
                (state is ShowAlert ? _buildText(state.message) : 
                (state is MemesEnded ? _buildText("Мемы коничились") : Container())))),
      )
    );
  }

  void _requestMeme(){
    widget.bloc.add(MemeRequested());
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

  void _showAlert(String message){
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
          _requestMeme();
        } else if (state is ShowMeme){
          savedMeme = state.meme;
        } else if(state is ShowError){
          _showError(state.message);
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