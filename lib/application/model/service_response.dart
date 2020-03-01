

abstract class ServiceResponse{

}

class Success<T> extends ServiceResponse{
  final T value;

  Success({this.value});
}

class Error extends ServiceResponse{
  String message;

  Error({this.message});
}