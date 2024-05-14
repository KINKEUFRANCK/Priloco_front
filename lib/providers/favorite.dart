import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<dynamic> _favorites = [];

  List<dynamic> get favorites => _favorites;
  set favorites (List<dynamic> value) {
    _favorites = value;
    notifyListeners();
  }
}
