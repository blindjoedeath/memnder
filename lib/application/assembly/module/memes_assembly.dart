import 'package:dioc/src/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/memes/memes_bloc.dart';
import 'package:memnder/application/bloc/memes/memes_event.dart';
import 'package:memnder/application/bloc/memes/memes_state.dart';
import 'package:memnder/application/service/authentication_service.dart';
import 'package:memnder/application/service/meme_service.dart';
import 'package:memnder/application/view/memes/memes_view.dart';
import 'package:memnder/application/extension/dioc//dioc_widget.dart';

class MemesAssembly extends ModuleAssembly<MemesView>{

  @override
  void assemble(Container container) {
    registerAsync((c)async{ 
      var service = c.get<AuthenticationServiceInterface>();
      await service.init();
    });

    container.register<Bloc<MemesEvent, MemesState>>((c){
      return MemesBloc(
        memeService: c.get<MemeServiceInterface>(),
        authenticationService: c.get<AuthenticationServiceInterface>()
      );
    });

    container.registerBuilder<MemesView>((context, container){
      return MemesView(
        bloc: container.create<Bloc<MemesEvent, MemesState>>(),
      );
    });

  }

    @override 
  void unload(Container container) {
    container.get<Bloc<MemesEvent, MemesState>>().close();
  }

}