

import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/registration/registration_bloc.dart';
import 'package:memnder/application/validator/form_validator.dart';
import 'package:memnder/application/validator/registration_validator.dart';
import 'package:memnder/application/view/registration/registration_view.dart';
import 'package:memnder/application/extension/dioc//dioc_widget.dart';

class RegistrationValidatorAssembly extends Assembly{

  @override
  void assemble(Container container) {

    container.register<FormValidator<RegistrationField>>(
      (c) => RegistrationValidator(),
      defaultMode: InjectMode.singleton);

  }

}