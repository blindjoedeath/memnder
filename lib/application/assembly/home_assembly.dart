import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/extension/di/widget/dioc_widget.dart';
import 'package:memnder/main.dart';

class HomeAssembly extends ModuleAssembly<MyHomePage>{

  @override
  void assemble(Container container) {
    container.registerBuilder<MyHomePage>((context, container){
      return MyHomePage(title: "title",);
    });
  }
}