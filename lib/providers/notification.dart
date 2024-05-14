import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List<dynamic> _notifications = [];

  List<dynamic> get notifications => _notifications;
  set notifications (List<dynamic> value) {
    _notifications = value;
    notifyListeners();
  }
}
