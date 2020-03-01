

enum SecureStorageKey{
  jwtCredentials
}

abstract class SecureStorageProviderInterface{
  Future<void> save<T>(SecureStorageKey key, T value);
  Future<T> load<T>(SecureStorageKey key);
}

class SecureStorageProvider extends SecureStorageProviderInterface{

  @override
  Future<void> save<T>(SecureStorageKey key, T value){
    
  }

  @override
  Future<T> load<T>(SecureStorageKey key){
    
  }
}

