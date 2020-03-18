import 'package:flutter/material.dart';
import 'package:http/http.dart' as client;
import 'package:memnder/application/api_model/api_response.dart';
import 'package:memnder/application/api_model/authentication_api_model.dart';
import 'package:memnder/application/api_model/registration_api_model.dart';
import 'package:memnder/application/entity/initable.dart';
import 'package:memnder/application/model/jwt_credentials.dart';
import 'dart:convert';

import 'package:memnder/application/provider/secure_storage_provider.dart';

class ApiBaseProvider extends ChangeNotifier implements Initable{
  var baseUrl = "https://memder.website";
  SecureStorageProviderInterface secureStorageProvider;

  Future init()async{
    var jwt = JwtCredentials();
    jwt = await secureStorageProvider.load(SecureStorageKey.jwtCredentials, jwt);
    _isAuthenticated = jwt != null;
  }

  bool _isAuthenticated;
  bool get isAuthenticated {
    return _isAuthenticated;
  }

  void changeState(bool authState){
    _isAuthenticated = authState;
    notifyListeners();
  }

  void logout()async{
    changeState(false);
    secureStorageProvider.save(SecureStorageKey.jwtCredentials, null);
  }

  Future<ApiResponse> authenticate(String username, String password)async{
    var url = baseUrl + '/api/signin_and_signup/token/';
    var body = jsonEncode({"username": username,
                           "password" : password});
    var response = await client.post(url, 
      headers: {"Content-Type": "application/json"},
      body: body
    );
    if (response.statusCode < 400){
      try{
        var json = jsonDecode(response.body);
        var auth = AuthenticationApiModel.fromJson(json);
        var jwt = JwtCredentials(
          accessToken: auth.access,
          refreshToken: auth.refresh,
          username: username,
          password: password
        );
        secureStorageProvider.save(SecureStorageKey.jwtCredentials, jwt);
        changeState(true);
        return ApiSuccess(
          value: auth
        );
      }
      catch(e){
        changeState(false);
        return ApiError();
      }
    } else {
      changeState(false);
      return ApiErrorDetail(
        statusCode: response.statusCode,
        message: jsonDecode(response.body)["detail"]
      );
    }
  }

    @override
  Future<ApiResponse> createUser(String username, String password)async {
    var url = baseUrl + '/api/signin_and_signup/createuser/';
    var body = jsonEncode({"username": username,
                           "password" : password});
    var response = await client.post(url, 
      headers: {"Content-Type": "application/json"},
      body: body
    );
    if (response.statusCode < 400){
      try{
        var json = jsonDecode(response.body);
        var reg = RegistrationApiModel.fromJson(json);
        var jwt = JwtCredentials(
          accessToken: reg.access,
          refreshToken: reg.refresh,
          username: username,
          password: password
        );
        await secureStorageProvider.save(SecureStorageKey.jwtCredentials, jwt);
        changeState(true);
        return ApiSuccess(
          value: reg
        );
      }
      catch(e){
        changeState(false);
        return ApiError();
      }
    } else{
      changeState(false);
      return ApiErrorDetail(
        message: jsonDecode(response.body)["detail"],
        statusCode: response.statusCode
      );
    }
  }

  Future<ApiResponse> refreshToken(JwtCredentials jwt)async{
    var url = baseUrl + "/api/signin_and_signup/token/refresh/";
    var body = jsonEncode({"refresh": jwt.refreshToken});
    var response = await client.post(url, 
      headers: {"Content-Type": "application/json"},
      body: body
    );

    if (response.statusCode == 401){
      return await authenticate(jwt.username, jwt.password);
    } else if (response.statusCode < 400){
      try{
        var json = jsonDecode(response.body);
        var access = json["access"];
        var newJwt = JwtCredentials(
          accessToken: access,
          refreshToken: jwt.refreshToken,
          username: jwt.username,
          password: jwt.password
        );
        await secureStorageProvider.save(SecureStorageKey.jwtCredentials, newJwt);
        changeState(true);
        return ApiSuccess(
          value: newJwt
        );
      }
      catch(e){
        changeState(false);
        return ApiError();
      }
    } else {
      changeState(false);
      return ApiErrorDetail(
        statusCode: response.statusCode,
        message: response.body
      );
    }
  }

  Future<ApiResponse> authorizedGetRequestImpl(String url, {bool isFirst = true})async{
    var jwt = JwtCredentials();
    jwt = await secureStorageProvider.load<JwtCredentials>(SecureStorageKey.jwtCredentials, jwt);
    if (jwt == null){
      return CredentialsError();
    }

    var token = jwt.accessToken;
    var response = await client.get(url, 
      headers: {
        "Content-Type": "application/json",
        "Authorization" : "Bearer $token"
      },
    );
    if (response.statusCode == 401){
      if (isFirst){
        var authResponse = await refreshToken(jwt);
        if (authResponse is ApiSuccess){
          return authorizedGetRequestImpl(url, isFirst: false);
        }
      } else {
        return ApiError();
      }
    } else{
      return ApiSuccess(
        value: response
      );
    } 
  }


  Future<ApiResponse> authorizedPostRequestImpl(String method, Map<String, Object> parameters, {bool isFirst = true})async{
    var jwt = JwtCredentials();
    jwt = await secureStorageProvider.load<JwtCredentials>(SecureStorageKey.jwtCredentials, jwt);
    if (jwt == null){
      return CredentialsError();
    }

    var token = jwt.accessToken;
    var response = await client.post(baseUrl + method, 
      headers: {
        "Content-Type": "application/json",
        "Authorization" : "Bearer $token"
      },
      body: parameters != null ? jsonEncode(parameters) : null
    );

    if (response.statusCode == 401){
      if (isFirst){
        var authResponse = await refreshToken(jwt);
        if (authResponse is ApiSuccess){
          return authorizedPostRequestImpl(method, parameters, isFirst: false);
        }
      } else {
        return ApiError();
      }
    } else{
      return ApiSuccess(
        value: response
      );
    } 
  }

  Future<ApiResponse> authorizedMultipartPostImpl(String method,
                                              Future Function(client.MultipartRequest) builder,
                                              {bool isFirst = true})async{
    var jwt = JwtCredentials();
    jwt = await secureStorageProvider.load<JwtCredentials>(SecureStorageKey.jwtCredentials, jwt);
    if (jwt == null){
      return CredentialsError();
    }

    var url = Uri.parse(baseUrl + method);
    var request = new client.MultipartRequest("POST", url);
    request.headers["Authorization"] = "Bearer ${jwt.accessToken}";

    await builder(request);
    var response = await request.send();
    if (response.statusCode == 401){
      if (isFirst){
        var authResponse = await refreshToken(jwt);
        if (authResponse is ApiSuccess){
          return authorizedMultipartPostImpl(method, builder, isFirst: false);
        }
      } else {
        return ApiError();
      }
    } else{
      return ApiSuccess(
        value: response
      );
    }
    return ApiError();
  }

  Future<ApiResponse> authorizedMultipartPost(String method, Future Function(client.MultipartRequest) builder)async{
    return authorizedMultipartPostImpl(method, builder);
  }

  Future<ApiResponse> authorizedGetRequestUrl(String url)async{
    return authorizedGetRequestImpl(url);
  }

  Future<ApiResponse> authorizedGetRequest(String method)async{
    return authorizedGetRequestImpl(baseUrl + method);
  }

  Future<ApiResponse> authorizedPostRequest(String method, Map<String, Object> parameters)async{
    return authorizedPostRequestImpl(method, parameters); 
  }

}