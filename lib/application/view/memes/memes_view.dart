

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/memes/memes_event.dart';
import 'package:memnder/application/bloc/memes/memes_state.dart';
import 'package:memnder/application/entity/meme_reaction.dart';
import 'package:memnder/application/model/meme_model.dart';

class MemesView extends StatefulWidget{

  final Bloc<MemesEvent, MemesState> bloc;

  const MemesView({@required this.bloc});

  @override
  State<StatefulWidget> createState() => _MemesViewState();
  
}

class _MemesViewState extends State<MemesView>{

  MemeModel meme;

  Widget _buildFloatingRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FloatingActionButton.extended(
          onPressed: () {
            widget.bloc.add(MemeReactionSet(
              meme: meme,
              reaction: MemeReaction.skip
            ));
          },
          label: Text('Пропустить'),
          icon: Icon(Icons.navigate_next),
          backgroundColor: Colors.black45
        ),
        FloatingActionButton.extended(
          onPressed: () {
            widget.bloc.add(MemeReactionSet(
              meme: meme,
              reaction: MemeReaction.like
            ));
          },
          label: Text('   Лайк   '),
          icon: Icon(Icons.thumb_up),
          backgroundColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildImage(String link){
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        link,
        filterQuality: FilterQuality.high,
        fit: BoxFit.fitWidth,
      ),
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
        child: (state is ShowMeme ? _buildImage(state.meme.imageLink) : 
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
            floatingActionButton: state is ShowMeme ? _buildFloatingRow() : null,
            body: _buildBody(state),
          );
        }
    );
  }

}