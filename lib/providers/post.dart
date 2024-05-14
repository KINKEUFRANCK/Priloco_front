import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  List<dynamic> _posts = [];
  List<dynamic> _similar_posts = [];
  dynamic _post = {};

  List<dynamic> get posts => _posts;
  set posts (List<dynamic> value) {
    _posts = value;
    notifyListeners();
  }

  List<dynamic> get similar_posts => _similar_posts;
  set similar_posts (List<dynamic> value) {
    _similar_posts = value;
    notifyListeners();
  }

  dynamic get post => _post;
  set post (dynamic value) {
    _post = value;
    notifyListeners();
  }
}
