 import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {


  void saveUser() {

    notifyListeners();
  }
}