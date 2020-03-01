

import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/authentication/authentication_bloc.dart';
import 'package:memnder/application/bloc/registration/registration_bloc.dart';
import 'package:memnder/application/view/root/root_view.dart';
import 'package:memnder/application/extension/dioc/dioc_lazy.dart';
import 'package:memnder/application/extension/dioc/dioc_widget.dart';

class RootViewAssembly extends ModuleAssembly<RootView>{

  @override
  void assemble(Container container) {
    container.registerBuilder<RootView>((context, container){
      return RootView(
        authenticationBloc: container.getLazy<AuthenticationBloc>(),
      );
    });    
  }

}