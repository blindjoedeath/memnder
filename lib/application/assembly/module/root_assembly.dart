import 'package:dioc/src/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/root/root_bloc.dart';
import 'package:memnder/application/bloc/root/root_event.dart';
import 'package:memnder/application/bloc/root/root_state.dart';
import 'package:memnder/application/service/authentication_service.dart';
import 'package:memnder/application/view/root/root_view.dart';
import 'package:memnder/application/extension/dioc//dioc_widget.dart';

class RootAssembly extends ModuleAssembly<RootView>{

  Bloc<RootEvent, RootState> _rootBloc;

  @override
  void assemble(Container container) {
    registerAsync((c)async{
      var service = c.get<AuthenticationServiceInterface>();
      await service.init();
    });

    container.register<Bloc<RootEvent, RootState>>((c){
      return RootBloc(
        authenticationService: c.get()
      );
    });

    container.registerBuilder<RootView>((context, c){
      _rootBloc?.close();
      return RootView(
        bloc: _rootBloc = c.create(),
      );
    });
  }

  @override 
  void unload(Container container) {
    _rootBloc.close();
  }

}
			