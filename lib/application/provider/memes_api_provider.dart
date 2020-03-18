import 'dart:convert';
import 'package:http/http.dart' as client;
import 'package:flutter/material.dart';
import 'package:memnder/application/api_model/api_response.dart';
import 'package:memnder/application/api_model/recomended_meme_api_model.dart';
import 'package:memnder/application/api_model/user_memes.dart';
import 'package:memnder/application/provider/api_base_provider.dart';
import 'package:http_parser/http_parser.dart';

abstract class MemesApiProviderInterface{
  Future<ApiResponse> recomededMeme();
  Future<ApiResponse> like(int memeId);
  Future<ApiResponse> dislike(int memeId);
  Future<ApiResponse> upload(List<List<int>> images);
  Future<ApiResponse> memesByUser();
  Future<ApiResponse> nextMemes();
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
        var meme = RecomendedMemeApiModel.fromJson(json);
        var urls = meme.images.map((link) => apiBaseProvider.baseUrl + link).toList();
        meme = meme.copyWith(images: urls);
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

  @override
  Future<ApiResponse> upload(List<List<int>> images)async{
    var apiResponse = await apiBaseProvider.authorizedMultipartPost("/api/memes/upload/", (request)async{
      for(int i = 0; i < images.length; ++i){
        var file = client.MultipartFile.fromBytes(
          'img_${i+1}',
          images[i],
          filename: 'img_${i+1}.jpg',
          contentType: MediaType("image", "jpeg"),
        );
        request.files.add(file);
      }
    });

    return apiResponse;
  }

  String _nextUrl;
  @override
  Future<ApiResponse> memesByUser()async{
    var apiResponse = await apiBaseProvider
      .authorizedGetRequest("/api/memes/memesbyuser/");

    if (apiResponse is! ApiSuccess){
      return apiResponse;
    }
    var response = (apiResponse as ApiSuccess<client.Response>).value;
    try{
      var json = jsonDecode(response.body);
      if (response.statusCode == 200){
        var model = UserMemesApiModel.fromJson(json);
        _nextUrl = model.next;
        return ApiSuccess(value: model);
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

  @override
  Future<ApiResponse> nextMemes()async{
    if (_nextUrl == null){
      return MemeEnd();
    }

    var apiResponse = await apiBaseProvider
      .authorizedGetRequestUrl(_nextUrl);

    if (apiResponse is! ApiSuccess){
      return apiResponse;
    }
    var response = (apiResponse as ApiSuccess<client.Response>).value;
    try{
      var json = jsonDecode(response.body);
      if (response.statusCode == 200){
        var model = UserMemesApiModel.fromJson(json);
        return ApiSuccess(value: model);
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