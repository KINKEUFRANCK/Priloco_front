import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic> _data = {};
  String _token = '';
  String _tokenRefresh = '';

  Map<String, dynamic> get data => _data;
  set data (Map<String, dynamic> value) {
    _data = value;
    notifyListeners();
  }

  String get token => _token;
  set token (String value) {
    _token = value;
    notifyListeners();
  }

  String get tokenRefresh => _tokenRefresh;
  set tokenRefresh (String value) {
    _tokenRefresh = value;
    notifyListeners();
  }
}
