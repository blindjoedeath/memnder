import 'package:dioc/src/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/account/account_event.dart';
import 'package:memnder/application/bloc/account/account_state.dart';
import 'package:memnder/application/bloc/memes/memes_event.dart';
import 'package:memnder/application/bloc/memes/memes_state.dart';
import 'package:memnder/application/bloc/app/app_bloc.dart';
import 'package:memnder/application/bloc/app/app_event.dart';
import 'package:memnder/application/bloc/app/app_state.dart';
import 'package:memnder/application/entity/lazy.dart';
import 'package:memnder/application/service/authentication_service.dart';
import 'package:memnder/application/view/app/app_view.dart';
import 'package:memnder/application/extension/dioc/dioc_lazy.dart';
import 'package:memnder/application/extension/dioc/dioc_widget.dart';

class AppAssembly extends ModuleAssembly<AppView>{

  Bloc<AppEvent, AppState> _appBloc;
  Lazy<Bloc<MemesEvent, MemesState>> _memesBloc;
  Lazy<Bloc<AccountEvent, AccountState>> _accountBloc;

  @override
  void assemble(Container container) {

    registerAsync((c)async{
      var service = c.get<AuthenticationServiceInterface>();
      await service.init();
    });

    container.register<Bloc<AppEvent, AppState>>((c){
      return AppBloc(
        authenticationService: c.get<AuthenticationServiceInterface>()
      );
    });

    container.registerBuilder<AppView>((context, c){
      return AppView(
        bloc: _appBloc = c.create(),
        memesBloc: _memesBloc = c.createLazy(),
        accountBloc: _accountBloc = c.createLazy(),
      );
    });    
  }

  @override 
  void unload(Container container) {
    _appBloc.close();
    _accountBloc.instance.close();
    _memesBloc.instance.close();
    _accountBloc.instance.close();
  }

}