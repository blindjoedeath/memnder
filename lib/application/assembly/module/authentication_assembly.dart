import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/authentication/authentication_bloc.dart';
import 'package:memnder/application/bloc/registration/registration_bloc.dart';
import 'package:memnder/application/validator/form_validator.dart';
import 'package:memnder/application/validator/registration_validator.dart';
import 'package:memnder/application/view/authentication/authentication_view.dart';
import 'package:memnder/application/view/registration/registration_view.dart';
import 'package:memnder/application/extension/dioc//dioc_widget.dart';

class AuthenticationAssembly extends ModuleAssembly<AuthenticationView>{

  @override
  void assemble(Container container) {
    container.register<AuthenticationBloc>((c){
      print("Create authentication bloc");
      return AuthenticationBloc(
        mapper: c.get(),
        formValidator: c.get()
      );
    });

    container.registerBuilder<AuthenticationView>((context, c){
      return AuthenticationView(
        bloc: c.get(),
      );
    });

  }

}