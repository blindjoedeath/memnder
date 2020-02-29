import 'package:dioc/dioc.dart';
import 'package:memnder/application/extension/di/lazy/lazy.dart';

extension LazyInjection on Container{
  Lazy<T> getLazy<T>({String name = null, String creator = null, InjectMode mode = InjectMode.unspecified}){
    return Lazy<T>(instanceFactory: () => this.get<T>(name: name, creator: creator, mode: mode));
  }
}