import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memnder/application/api_model/api_response.dart';
import 'package:memnder/application/api_model/authentication_api_model.dart';
import 'package:memnder/application/entity/initable.dart';
import 'package:memnder/application/model/authentication_model.dart';
import 'package:memnder/application/model/jwt_credentials.dart';
import 'package:memnder/application/model/registration_model.dart';
import 'package:memnder/application/model/service_response.dart';
import 'package:memnder/application/provider/api_base_provider.dart';
import 'package:memnder/application/provider/secure_storage_provider.dart';

abstract class AuthenticationServiceInterface extends ChangeNotifier implements Initable{
  Future<ServiceResponse> authenticate(AuthenticationModel authentication);
  void logout();

  bool get isAuthenticated;
}

class AuthenticationService extends AuthenticationServiceInterface{

  ApiBaseProvider apiBaseProvider;

  void authListener(){
    notifyListeners();
  }

  Future init()async{
    apiBaseProvider.addListener(authListener);
    return await apiBaseProvider.init();
  }

  @override
  void dispose(){
    super.dispose();
    apiBaseProvider.removeListener(authListener);
  }

  @override
  bool get isAuthenticated{
    return apiBaseProvider.isAuthenticated;
  }

  void logout(){
    apiBaseProvider.logout();
  }

  @override
  Future<ServiceResponse> authenticate(AuthenticationModel authentication) async{
    var response = await apiBaseProvider.authenticate(
      authentication.login,
      authentication.password
    );
    if (response is ApiSuccess<AuthenticationApiModel>){
      return Success(
        value: true
      );
    }
    if (response is ApiErrorDetail){
      return Error(
        message: response.message
      );
    }
    return Error();
  }
  
}