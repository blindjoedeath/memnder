import 'package:dioc/dioc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/mapper/authentication_mapper.dart';
import 'package:memnder/application/mapper/mapper.dart';
import 'package:memnder/application/model/authentication_model.dart';
import 'package:memnder/application/view_model/authentication_view_model.dart';

class AuthenticationMapperAssembly extends Assembly{

  @override
  void assemble(Container container) {
    container.register<Mapper<AuthenticationModel, AuthenticationViewModel>>(
      (c) => AuthenticationMapper(),
      defaultMode: InjectMode.singleton);

  }

}