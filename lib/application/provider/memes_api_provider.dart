import 'dart:convert';
import 'package:http/http.dart' as client;
import 'package:flutter/material.dart';
import 'package:memnder/application/api_model/api_response.dart';
import 'package:memnder/application/api_model/recomended_meme_api_model.dart';
import 'package:memnder/application/provider/api_base_provider.dart';

abstract class MemesApiProviderInterface{
  Future<ApiResponse> recomededMeme();
  Future<ApiResponse> like(int memeId);
  Future<ApiResponse> dislike(int memeId);
}

class MemeEnd extends ApiResponse{}

class MemesApiProvider extends MemesApiProviderInterface{

  final ApiBaseProvider apiBaseProvider;

  MemesApiProvider(
    {
      @required this.apiBaseProvider
    }
  );

  Future<ApiResponse> recomededMeme()async{
    var apiResponse = await apiBaseProvider.authorizedGetRequest("/api/memes/recomendedmem/");

    if (apiResponse is! ApiSuccess){
      return apiResponse;
    }
    var response = (apiResponse as ApiSuccess<client.Response>).value;

    if (response.statusCode == 204){
      return MemeEnd();
    }
    try{
      var json = jsonDecode(response.body);
      if (response.statusCode == 200){
        var meme = RecomededMemeApiModel.fromJson(json);
        var urls = meme.images.map((link) => apiBaseProvider.baseUrl + link).toList();
        meme = meme.copyWith(images: urls);
        print(meme.id);
        return ApiSuccess(
          value: meme
        );
      } else{
        return ApiErrorDetail(
          message: json["detail"],
          statusCode: response.statusCode
        );
      }
    }
    catch(e){
      return ApiError();
    }

  }

  Future<ApiResponse> like(int memeId)async{
    
    print(memeId);
    var apiResponse = await apiBaseProvider
      .authorizedPostRequest("/api/memes/like/$memeId/", null);

    if (apiResponse is! ApiSuccess){
      return apiResponse;
    }
    var response = (apiResponse as ApiSuccess<client.Response>).value;

    try{
      var json = jsonDecode(response.body);
      if (response.statusCode == 200){
        return ApiSuccess(value: null);
      } else{
        return ApiErrorDetail(
          message: json["detail"],
          statusCode: response.statusCode
        );
      }
    }
    catch(e){
      return ApiError();
    }
  }

  Future<ApiResponse> dislike(int memeId)async{
    var apiResponse = await apiBaseProvider
      .authorizedPostRequest("/api/memes/dislike/$memeId/", null);

    if (apiResponse is! ApiSuccess){
      return apiResponse;
    }
    var response = (apiResponse as ApiSuccess<client.Response>).value;

    try{
      var json = jsonDecode(response.body);
      if (response.statusCode == 200){
        return ApiSuccess(value: null);
      } else{
        return ApiErrorDetail(
          message: json["detail"],
          statusCode: response.statusCode
        );
      }
    }
    catch(e){
      return ApiError();
    }
  }
}