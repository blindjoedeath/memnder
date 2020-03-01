

import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/service/registration_service.dart';

class RegistrationServiceAssembly extends Assembly{

  @override
  void assemble(Container container) {
    container.register<RegistrationServiceInterface>(
      (c) => RegistrationService(),
      defaultMode: InjectMode.singleton);
  }

}