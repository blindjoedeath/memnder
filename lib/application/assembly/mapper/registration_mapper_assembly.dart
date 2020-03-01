import 'package:dioc/dioc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/mapper/mapper.dart';
import 'package:memnder/application/mapper/registration_mapper.dart';
import 'package:memnder/application/model/registration_model.dart';
import 'package:memnder/application/view_model/registration_view_model.dart';

class RegistrationMapperAssemly extends Assembly{

  @override
  void assemble(Container container) {
    container.register<Mapper<RegistrationModel, RegistrationViewModel>>(
      (c) => RegistrationMapper(),
      defaultMode: InjectMode.singleton);

  }

}