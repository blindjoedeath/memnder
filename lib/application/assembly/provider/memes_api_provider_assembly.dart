import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/provider/api_base_provider.dart';
import 'package:memnder/application/provider/memes_api_provider.dart';

class MemesApiProviderAssembly extends Assembly{

  @override
  void assemble(Container container) {
    container.register<MemesApiProviderInterface>((c){
      var provider = MemesApiProvider(
        apiBaseProvider: c.get()
      );
      return provider;
    }, defaultMode: InjectMode.singleton);
  }
  
}