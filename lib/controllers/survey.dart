import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bonsplans/configs/routes.dart';

class SurveyController extends GetxController{
  final _survey = {}.obs;

  Map get survey => _survey.value;
  set survey(Map value) => _survey.value = value;
}
