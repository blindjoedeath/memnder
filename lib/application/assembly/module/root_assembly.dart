import 'package:dioc/src/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/account/account_event.dart';
import 'package:memnder/application/bloc/account/account_state.dart';
import 'package:memnder/application/bloc/authentication/authentication_bloc.dart';
import 'package:memnder/application/bloc/authentication/authentication_event.dart';
import 'package:memnder/application/bloc/authentication/authentication_state.dart';
import 'package:memnder/application/bloc/memes/memes_event.dart';
import 'package:memnder/application/bloc/memes/memes_state.dart';
import 'package:memnder/application/bloc/registration/registration_bloc.dart';
import 'package:memnder/application/bloc/root/root_bloc.dart';
import 'package:memnder/application/bloc/root/root_event.dart';
import 'package:memnder/application/bloc/root/root_state.dart';
import 'package:memnder/application/service/authentication_service.dart';
import 'package:memnder/application/view/root/root_view.dart';
import 'package:memnder/application/extension/dioc/dioc_lazy.dart';
import 'package:memnder/application/extension/dioc/dioc_widget.dart';

class RootViewAssembly extends ModuleAssembly<RootView>{

  @override
  void assemble(Container container) {

    registerAsync((c)async{
      var service = c.get<AuthenticationServiceInterface>();
      await service.init();
    });

    container.register<Bloc<RootEvent, RootState>>((c){
      var bloc = RootBloc(
        authenticationService: c.get()
      );
      return bloc;
    });

    container.registerBuilder<RootView>((context, c){
      
      return RootView(
        bloc: c.get(),
        authenticationBloc: c.getLazy<Bloc<AuthenticationEvent, AuthenticationState>>(),
        memesBloc: c.getLazy<Bloc<MemesEvent, MemesState>>(),
        accountBloc: c.getLazy<Bloc<AccountEvent, AccountState>>(),
      );
    });    
  }

}