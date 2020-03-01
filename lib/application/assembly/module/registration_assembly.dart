import 'package:dioc/src/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/registration/registration_bloc.dart';
import 'package:memnder/application/bloc/registration/registration_event.dart';
import 'package:memnder/application/bloc/registration/registration_state.dart';
import 'package:memnder/application/service/registration_service.dart';
import 'package:memnder/application/validator/form_validator.dart';
import 'package:memnder/application/validator/registration_validator.dart';
import 'package:memnder/application/view/registration/registration_view.dart';
import 'package:memnder/application/extension/dioc//dioc_widget.dart';

class RegistrationAssembly extends ModuleAssembly<RegistrationView>{

  @override
  void assemble(Container container) {
    container.register<Bloc<RegistrationEvent, RegistrationState>>((c){
      return RegistrationBloc(
        registrationService: c.get(),
        mapper: c.get(),
        formValidator: c.get()
      );
    });

    container.registerBuilder<RegistrationView>((context, container){
      return RegistrationView(
        bloc: container.get(),
      );
    });

  }

}