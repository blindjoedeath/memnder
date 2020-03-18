import 'package:http/http.dart';
import 'package:memnder/application/api_model/api_response.dart';
import 'package:memnder/application/api_model/recomended_meme_api_model.dart';
import 'package:memnder/application/api_model/user_memes.dart';
import 'package:memnder/application/entity/meme_reaction.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:memnder/application/model/service_response.dart';
import 'package:memnder/application/provider/memes_api_provider.dart';


abstract class MemeServiceInterface{
  Future<ServiceResponse> getMeme();
  Future<ServiceResponse> setMemeReaction(int memeId, MemeReaction reaction);
  Future<ServiceResponse> upload(List<List<int>> images);
  Future<ServiceResponse> getUserMemes();
  Future<ServiceResponse> nextMemes();
}


class MemeService extends MemeServiceInterface{

  MemesApiProviderInterface memesApiProvider;

  @override
  Future<ServiceResponse> getMeme()async {
    var response = await memesApiProvider.recomededMeme();
    if (response is ApiSuccess<RecomendedMemeApiModel>){
      var model = MemeModel(
        id: response.value.id,
        likes: response.value.likes,
        dislikes: response.value.dislikes,
        images: response.value.images,
      );
      return Success(value: model);
    } else if (response is ApiErrorDetail){
      return Error(
        message: response.message
      );
    } else if (response is MemeEnd){
      return Success(
        value: "Мемы кончились"
      );
    }
    return Error();
  }

  @override
  Future<ServiceResponse> setMemeReaction(int memeId, MemeReaction reaction)async {
    var response = await (reaction == MemeReaction.like ?
       memesApiProvider.like(memeId) :
      memesApiProvider.dislike(memeId));
    if (response is ApiSuccess){
      return Success(value: null);
    } else if (response is ApiErrorDetail){
      return Error(
        message: response.message
      );
    }
    return Error();
  }

  @override
  Future<ServiceResponse> upload(List<List<int>> images) async{
    var response = await memesApiProvider.upload(images);
    print(response);
    if (response is ApiSuccess<StreamedResponse> && response.value.statusCode < 300){
      return Success(value: null);
    } else if (response is ApiErrorDetail){
      return Error(
        message: response.message
      );
    }
    return Error();
  }

  @override
  Future<ServiceResponse> getUserMemes()async {
    var response = await memesApiProvider.memesByUser();
    if (response is ApiSuccess<UserMemesApiModel>){
      var memeModels = response.value.memes.map((m) => 
        MemeModel(
          id: m.id,
          likes: m.likes,
          dislikes: m.dislikes,
          author: m.author,
          images: m.images
        )
      ).toList();
      return Success(value: memeModels);
    } else if (response is ApiErrorDetail){
      return Error(
        message: response.message
      );
    }
    return Error();
  }

  @override
  Future<ServiceResponse> nextMemes()async {
    var response = await memesApiProvider.nextMemes();
    if (response is ApiSuccess<UserMemesApiModel>){
      var memeModels = response.value.memes.map((m) => 
        MemeModel(
          id: m.id,
          likes: m.likes,
          dislikes: m.dislikes,
          author: m.author,
          images: m.images
        )
      ).toList();
      return Success(value: memeModels);
    } else if (response is MemeEnd){
      return Success(
        value: "Мемы кончились"
      );
    }
    else if (response is ApiErrorDetail){
      return Error(
        message: response.message
      );
    }
    return Error();
  }


}