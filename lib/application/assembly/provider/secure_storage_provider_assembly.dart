
import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/provider/secure_storage_provider.dart';

class SecureStorageProviderAssembly extends Assembly{

  @override
  void assemble(Container container) {
    container.register<SecureStorageProviderInterface>((c){
      var provider = SecureStorageProvider();
      return provider;
    }, defaultMode: InjectMode.singleton);
  }
  
}