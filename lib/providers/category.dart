import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<dynamic> _categories = [];
  List<dynamic> _all_categories = [];

  List<dynamic> get categories => _categories;
  set categories (List<dynamic> value) {
    _categories = value;
    notifyListeners();
  }

  List<dynamic> get all_categories => _all_categories;
  set all_categories (List<dynamic> value) {
    _all_categories = value;
    notifyListeners();
  }
}
