import 'package:flutter/material.dart';

class SurveyProvider extends ChangeNotifier {
  List<dynamic> _surveys = [];
  dynamic _survey = {};

  List<dynamic> get surveys => _surveys;
  set surveys (List<dynamic> value) {
    _surveys = value;
    notifyListeners();
  }

  dynamic get survey => _survey;
  set survey (dynamic value) {
    _survey = value;
    notifyListeners();
  }
}
