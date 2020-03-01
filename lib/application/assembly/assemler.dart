
import 'package:dioc/dioc.dart';
import 'package:flutter/material.dart' hide Container;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/assembly/mapper/authentication_mapper_assemly.dart';
import 'package:memnder/application/assembly/mapper/registration_mapper_assembly.dart';
import 'package:memnder/application/assembly/module/authentication_assembly.dart';
import 'package:memnder/application/assembly/module/registration_assembly.dart';
import 'package:memnder/application/assembly/module/root_assembly.dart';
import 'package:memnder/application/assembly/service/registration_service_assembly.dart';
import 'package:memnder/application/assembly/validator/authentication_validator.dart';
import 'package:memnder/application/assembly/validator/registration_validator_assembly.dart';
import 'package:memnder/main.dart';

class Assembler{
  
  Map<String, ModuleAssembly> routes = {
    "/" : RootViewAssembly(),
    "/registration" : RegistrationAssembly(),
    "/authentication" : AuthenticationAssembly()
  };

  List<Assembly> services = [
    RegistrationServiceAssembly()
  ];

  List<Assembly> mappers = [
    RegistrationMapperAssemly(),
    AuthenticationMapperAssembly()
  ];


  List<Assembly> validators = [
    RegistrationValidatorAssembly(),
    AuthenticationValidatorAssembly()
  ];

  Container container;

  Map<String, Widget Function(BuildContext)> generateRoutes(){

    container = Container();

    services.forEach((value){
      value.assemble(container);
    });

    mappers.forEach((value){
      value.assemble(container);
    });

    validators.forEach((value){
      value.assemble(container);
    });

    routes.forEach((key, value){
      value.assemble(container);
    });

    return routes.map((key, value){
      return MapEntry(key, (c) => value.getView(c, container));
    });
  }

  Future prepareNamed(String route){
    return routes[route].prepare(container);
  }

}