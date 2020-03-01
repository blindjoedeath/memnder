import 'package:memnder/application/api_model/api_response.dart';
import 'package:memnder/application/api_model/registration_api_model.dart';
import 'package:memnder/application/model/authentication_model.dart';
import 'package:memnder/application/model/jwt_credentials.dart';
import 'package:memnder/application/model/registration_model.dart';
import 'package:memnder/application/model/service_response.dart';
import 'package:memnder/application/provider/api_base_provider.dart';
import 'package:memnder/application/provider/secure_storage_provider.dart';

abstract class RegistrationServiceInterface{
  Future<ServiceResponse> register(RegistrationModel registration);
}

class RegistrationService extends RegistrationServiceInterface{

  ApiBaseProvider apiBaseProvider;

  @override
  Future<ServiceResponse> register(RegistrationModel registration) async{
    var response = await apiBaseProvider.createUser(
      registration.login,
      registration.password
    );

    if (response is ApiSuccess<RegistrationApiModel>){
      return Success(
        value: true
      );
    } else if (response is ApiErrorDetail){
      return Error(
        message: response.message
      );
    }
    return Error();
  }
  
}