

import 'package:memnder/application/mapper/mapper.dart';
import 'package:memnder/application/model/registration_model.dart';
import 'package:memnder/application/view_model/registration_view_model.dart';

class RegistrationMapper extends Mapper<RegistrationModel, RegistrationViewModel>{

  @override
  RegistrationModel mapToModel(RegistrationViewModel viewModel){
    return RegistrationModel(
      login: viewModel.login,
      password: viewModel.password,
    );
  }

}