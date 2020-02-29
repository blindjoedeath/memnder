import 'package:flutter/material.dart';

class Lazy<T>{

  T _instance;

  T get instance{
    return _instance == null ? _instance = _instanceFactory() : _instance;
  }

  T Function() _instanceFactory;

  Lazy({@required instanceFactory}) : assert(instanceFactory != null){
    this._instanceFactory = instanceFactory;
  }

}