import 'package:memnder/application/api_model/api_response.dart';
import 'package:memnder/application/api_model/recomended_meme_api_model.dart';
import 'package:memnder/application/api_model/registration_api_model.dart';
import 'package:memnder/application/entity/meme_reaction.dart';
import 'package:memnder/application/model/authentication_model.dart';
import 'package:memnder/application/model/jwt_credentials.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:memnder/application/model/registration_model.dart';
import 'package:memnder/application/model/service_response.dart';
import 'package:memnder/application/provider/api_base_provider.dart';
import 'package:memnder/application/provider/memes_api_provider.dart';
import 'package:memnder/application/provider/secure_storage_provider.dart';

abstract class MemeServiceInterface{
  Future<ServiceResponse> getMeme();
  Future<ServiceResponse> setMemeReaction(int memeId, MemeReaction reaction);
}


class MemeService extends MemeServiceInterface{

  MemesApiProviderInterface memesApiProvider;

  @override
  Future<ServiceResponse> getMeme()async {
    var response = await memesApiProvider.recomededMeme();
    if (response is ApiSuccess<RecomededMemeApiModel>){
      var result = (response as ApiSuccess<RecomededMemeApiModel>);
      var model = MemeModel(
        id: result.value.id,
        imageLink: result.value.images[0],
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
    print(response);
    if (response is ApiSuccess){
      return Success(value: null);
    } else if (response is ApiErrorDetail){
      return Error(
        message: response.message
      );
    }
    return Error();
  }

}