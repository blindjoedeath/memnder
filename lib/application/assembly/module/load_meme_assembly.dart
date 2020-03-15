import 'package:dioc/src/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/load_meme/load_meme_bloc.dart';
import 'package:memnder/application/bloc/load_meme/load_meme_event.dart';
import 'package:memnder/application/bloc/load_meme/load_meme_state.dart';
import 'package:memnder/application/view/load_meme/load_meme_view.dart';
import 'package:memnder/application/extension/dioc//dioc_widget.dart';

class LoadMemeAssembly extends ModuleAssembly<LoadMemeView>{

  Bloc<LoadMemeEvent, LoadMemeState> _loadMemeBloc;

  @override
  void assemble(Container container) {
    container.register<Bloc<LoadMemeEvent, LoadMemeState>>((c){
      return LoadMemeBloc(
        memeService: c.get()
      );
    });

    container.registerBuilder<LoadMemeView>((context, c){
      _loadMemeBloc?.close();
      return LoadMemeView(
        bloc: _loadMemeBloc = c.create(),
      );
    });
  }

  @override 
  void unload(Container container) {
    _loadMemeBloc.close();
  }

}
			