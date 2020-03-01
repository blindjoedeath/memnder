import 'package:memnder/application/mapper/mapper.dart';
import 'package:memnder/application/model/authentication_model.dart';
import 'package:memnder/application/view_model/authentication_view_model.dart';

class AuthenticationMapper extends Mapper<AuthenticationModel, AuthenticationViewModel>{

  @override
  AuthenticationModel mapToModel(AuthenticationViewModel viewModel){
    return AuthenticationModel(
      login: viewModel.login,
      password: viewModel.password,
    );
  }

}