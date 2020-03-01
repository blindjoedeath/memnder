import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/service/meme_service.dart';
import 'package:memnder/application/service/registration_service.dart';

class MemeServiceAssembly extends Assembly{

  @override
  void assemble(Container container) {

    container.register<MemeServiceInterface>(
      (c){
        var service = MemeService();
        service.memesApiProvider = c.get();
        return service;
      },
      defaultMode: InjectMode.singleton);
  }

}