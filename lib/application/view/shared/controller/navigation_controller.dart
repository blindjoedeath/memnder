
import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier{
 void navigatorPopped(){
   notifyListeners();
 }
}