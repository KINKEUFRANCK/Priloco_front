import 'package:flutter/material.dart';

class FavoriteCategoryProvider extends ChangeNotifier {
  List<dynamic> _favoritecategories = [];

  List<dynamic> get favoritecategories => _favoritecategories;
  set favoritecategories (List<dynamic> value) {
    _favoritecategories = value;
    notifyListeners();
  }
}
