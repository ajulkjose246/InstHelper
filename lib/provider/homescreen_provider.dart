import 'package:flutter/material.dart';

class HomescreenProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateMyVariable({required int newValue}) {
    _selectedIndex = newValue;
    notifyListeners();
  }
}
