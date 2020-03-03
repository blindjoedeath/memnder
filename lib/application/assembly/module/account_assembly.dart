import 'package:dioc/src/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/account/account_bloc.dart';
import 'package:memnder/application/bloc/account/account_event.dart';
import 'package:memnder/application/bloc/account/account_state.dart';
import 'package:memnder/application/bloc/authentication/authentication_bloc.dart';
import 'package:memnder/application/bloc/authentication/authentication_event.dart';
import 'package:memnder/application/bloc/authentication/authentication_state.dart';
import 'package:memnder/application/service/authentication_service.dart';
import 'package:memnder/application/view/account/account_view.dart';
import 'package:memnder/application/view/authentication/authentication_view.dart';
import 'package:memnder/application/extension/dioc//dioc_widget.dart';

class AccountAssembly extends ModuleAssembly<AccountView>{

  @override
  void assemble(Container container) {
    container.register<Bloc<AccountEvent, AccountState>>((c){
      return AccountBloc(
        authenticationService: c.get<AuthenticationServiceInterface>(),
      );
    });

    container.registerBuilder<AccountView>((context, c){
      return AccountView(
        bloc: c.create<Bloc<AccountEvent, AccountState>>(),
      );
    });
  }

  @override 
  void unload(Container container) {
    container.get<Bloc<AccountEvent, AccountState>>().close();
  }

}