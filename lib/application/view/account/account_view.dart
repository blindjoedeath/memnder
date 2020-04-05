

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
import 'package:memnder/application/view/shared/controller/navigation_controller.dart';
import 'package:memnder/application/view/shared/screen/meme_detail.dart';

class AccountView extends StatefulWidget{

  final Bloc<AccountEvent, AccountState> bloc;
  final NavigationController navigationController;

  const AccountView(
    {
      @required this.bloc,
      this.navigationController
    }
  );

  @override
  State<StatefulWidget> createState() => _AccountViewState();

}

class _IndexModel{
  int index = 0;
  SwiperController swiperController = SwiperController();
}

class _AccountViewState extends State<AccountView>{

  Map<MemeModel, _IndexModel> _indexes = Map<MemeModel, _IndexModel>();
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

  void _navigationListener(){
    widget.bloc.add(MemesRequested());
  }

  @override
  void initState(){
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    widget.navigationController?.addListener(_navigationListener);
  }

  @override
  void dispose(){
    super.dispose();
    widget.bloc.add(AccountClosed());
    _scrollController.removeListener(_scrollListener);
    widget.navigationController?.removeListener(_navigationListener);
  }

  Widget _buildImage(String image){
    return TransitionToImage(
      fit: BoxFit.contain,
      height: 240,
      image: AdvancedNetworkImage(
        image,
      ),
      placeholder: CircularProgressIndicator()
    );
  }

  Widget _buildMemePicture(MemeModel meme){
    if (meme.images.length > 1){
      return SizedBox(
        height: 256,
        child: Swiper(
          controller: _indexes[meme].swiperController,
          itemCount: meme.images.length,
          itemBuilder: (context, i){
            return _buildImage(meme.images[i]);
          },
          loop: false,
          onIndexChanged: (i) => _indexes[meme].index = i,
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
    _indexes[meme].index = received;
    await _indexes[meme].swiperController.move(received, animation: false);   
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
                index = _indexes[meme].index;
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
        var meme = memes[i];
        if (!_indexes.containsKey(meme)){
          _indexes[meme] = _IndexModel();
        }
        return _buildMemePost(meme);
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
          _isScrolled = false;
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
            style: Theme.of(context).textTheme.display1.copyWith(fontSize: 32)
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