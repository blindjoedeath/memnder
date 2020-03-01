
import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/provider/api_base_provider.dart';

class ApiBaseProviderAssembly extends Assembly{

  @override
  void assemble(Container container) {
    container.register<ApiBaseProvider>((c){
      var provider = ApiBaseProvider();
      provider.secureStorageProvider = c.get();
      return provider;
    }, defaultMode: InjectMode.singleton);
  }
  
}