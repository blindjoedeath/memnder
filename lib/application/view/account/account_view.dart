

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:memnder/application/bloc/account/account_event.dart';
import 'package:memnder/application/bloc/account/account_state.dart';
import 'package:memnder/application/manager/route/route_manager.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:memnder/application/view/shared/button/sign_button.dart';
import 'package:memnder/application/view/shared/screen/meme_detail.dart';

class AccountView extends StatefulWidget{

  final Bloc<AccountEvent, AccountState> bloc;

  const AccountView(
    {
      @required this.bloc
    }
  );

  @override
  State<StatefulWidget> createState() => _AccountViewState();

}

class _AccountViewState extends State<AccountView>{

  Map<MemeModel, int> _indexes = Map<MemeModel, int>();
  ScrollController _scrollController;
  bool _isScrolled = false;
  List<MemeModel> _memes;

  void _scrollListener(){
     _scrollController.addListener(() {
        if (_scrollController.position.outOfRange){
          if (_scrollController.offset > _scrollController.position.maxScrollExtent && !_isScrolled){
            _isScrolled = true;
            widget.bloc.add(MoreMemesRequested());
          }
        }
     });
  }

  @override
  void initState(){
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose(){
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  Widget _buildImage(String image){
    return TransitionToImage(
      fit: BoxFit.contain,
      height: 240,
      image: AdvancedNetworkImage(
        image,
      ),
      placeholder: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.blue),
      )
    );
  }

  Widget _buildMemePicture(MemeModel meme){
    if (meme.images.length > 1){
      return SizedBox(
        height: 256,
        child: Swiper(
          itemCount: meme.images.length,
          itemBuilder: (context, i){
            return _buildImage(meme.images[i]);
          },
          loop: false,
          onIndexChanged: (i) => _indexes[meme] = i,
          pagination: SwiperPagination(
            margin: EdgeInsets.all(5),
            builder: DotSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: Colors.blue,
              size: 6,
              activeSize: 6
            )
          ),
        )
      );
    }
    return _buildImage(meme.images[0]);
  }

  Widget _buildMemeStatistics(MemeModel meme){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton.icon(
          disabledTextColor: Colors.grey,
          onPressed: null,
          icon: Icon(Icons.thumb_down),
          label: Text(meme.dislikes.toString())
        ),
        FlatButton.icon(
          disabledTextColor: Colors.green,
          onPressed: null,
          icon: Icon(Icons.thumb_up),
          label: Text(meme.likes.toString())
        ),
      ],
    );
  }

  void _showDetail(MemeModel meme, int index)async{
    int received = await Navigator.push(context,
      MaterialPageRoute(
        builder: (context){
          return MemeDetail(
            images: meme.images,
            initialPage: index,
          );
        },
        fullscreenDialog: true
      )
    );   
  }

  Widget _buildMemePost(MemeModel meme){
    return Card(
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: _buildMemePicture(meme),
            onTap: (){
              var index = 0;
              if (_indexes.containsKey(meme)){
                index = _indexes[meme];
              }
              _showDetail(meme, index);
            },
          ),
          _buildMemeStatistics(meme)
        ],
      ),
    );
  }

  Widget _buildList(List<MemeModel> memes){
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, i){
        return _buildMemePost(memes[i]);
      },
      itemCount: memes.length,
    );
  }

  Widget _buildLoading(){
    return Center(
      child: CircularProgressIndicator()
    );
  }

  Widget _buildBody(){
    return BlocBuilder<Bloc<AccountEvent, AccountState>, AccountState>(
      bloc: widget.bloc,
      builder: (context, state){
        if (state is Initial){
          widget.bloc.add(MemesRequested());
        } else if (state is Loading){
          return _buildLoading();
        } else if (state is LoadedMemes && state.memes.length > 0){
          _memes = state.memes;
          return _buildList(_memes);
        } else if (state is MoreLoadedMemes){
          _memes.addAll(state.memes);
          _isScrolled = false;
          return _buildList(_memes);
        }
        return Center(
          child: Text(
            "Загруженные мемы",
            style: Theme.of(context).textTheme.display1,
          )
        );
      }
    );
  }

  void _logout()async{
    widget.bloc.add(Logout());
    await RouteManager.prepareNamed("/authentication");
    Navigator.pushReplacementNamed(context, "/authentication");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Мои мемы"),
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: (){
            widget.bloc.add(MemesRequested());
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

}