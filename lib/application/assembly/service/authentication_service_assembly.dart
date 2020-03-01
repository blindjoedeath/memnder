import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/service/authentication_service.dart';

class AuthenticationServiceAssembly extends Assembly{

  @override
  void assemble(Container container) {
    container.register<AuthenticationServiceInterface>(
      (c){
        var service = AuthenticationService();
        service.apiBaseProvider = c.get();
        return service;
      },
      defaultMode: InjectMode.singleton);
  }

}