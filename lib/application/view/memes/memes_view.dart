

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
import 'package:memnder/application/view/shared/controller/navigation_controller.dart';
import 'package:memnder/application/view/shared/indicator/rjuman_spinner.dart';
import 'package:memnder/application/view/shared/route/fade_route.dart';
import 'package:memnder/application/view/shared/screen/meme_detail.dart';
import 'package:memnder/application/view/shared/swipeable/draggable_card.dart';
import 'package:memnder/application/view/shared/swipeable/image_preloader.dart';
import 'package:memnder/application/view/shared/swipeable/swipeable_card.dart';

class MemesView extends StatefulWidget{

  final Bloc<MemesEvent, MemesState> bloc;
  final NavigationController navigationController;

  const MemesView({@required this.bloc, this.navigationController});

  @override
  State<StatefulWidget> createState() => _MemesViewState();
  
}

class _MemesViewState extends State<MemesView> with SingleTickerProviderStateMixin{

  int _currentIndex = 0;

  void _navigationListener(){
    if (widget.bloc.state is MemesEnded){
      _requestMeme();
    }
  }

  @override
  void initState(){
    super.initState();

    widget.navigationController?.addListener(_navigationListener);

    if (widget.bloc.state is MemesEnded){
      _requestMeme();
    }
  }

  @override
  void dispose(){
    super.dispose();
    widget.navigationController?.removeListener(_navigationListener);
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

  void _precacheMeme(MemeNeedToPrecache state)async{
    _currentIndex = 0;
    var images = await ImagePreloader.preload(state.meme.images);
    widget.bloc.add(PrecachedImages(meme: state.meme, preloaded: images));
  }

  void _showDetail(MemeModel meme){
    Navigator.push(context, 
      FadeRoute(
        pageBuilder: (c, a1, a2) => MemeDetail(
          images: meme.images,
          initialPage: _currentIndex,
          indexChanged: (i) => setState(() => _currentIndex = i),
        ),
      )
    );
  }

  void _setMemeReaction(MemeModel meme, SlideDirection direction){
    var reaction = direction == SlideDirection.left ? MemeReaction.skip : MemeReaction.like;
    widget.bloc.add(MemeReactionSet(meme: meme, reaction: reaction));
  }

  Widget _buildMemeCard(ShowMeme state){
    return Align(
      alignment: Alignment.center,
      child: SwipeableCard(
        images: state.images,
        indexChanged: (i) => _currentIndex = i,
        initialIndex: _currentIndex,
        onSlide: (direction){
          if (direction == SlideDirection.down){
            _showDetail(state.meme);
          } else{
            _setMemeReaction(state.meme, direction);
          }
        },
      )
    );
  }

  Widget _buildSpinner(){
    return Center(
      child: RjumanSpinner()
    );
  }

  Widget _buildMemesEnded(){
    return Center(
      child: Text(
        "Мемы кончились",
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 32)
      ) 
    );
  }

  Widget _buildBody(MemesState state){
    if (state is ShowMeme){
      return _buildMemeCard(state);
    } else if(state is Loading || state is MemeNeedToPrecache){
      return _buildSpinner();
    } else if (state is MemesEnded){
      return _buildMemesEnded();
    }
    return Container();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc<MemesEvent, MemesState>, MemesState>(
      bloc: widget.bloc,
      builder: (context, state){
        if (state is Initial){
          _requestMeme();
        } else if(state is ShowError){
          _showError(state.message);
        } else if (state is MemeNeedToPrecache){
          _precacheMeme(state);
        }
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color.fromARGB(100, 219, 207, 255),
          body: _buildBody(state),
        );
      }
    );
  }

}