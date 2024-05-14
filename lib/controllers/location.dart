import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bonsplans/configs/constants.dart';

class LocationController extends GetxController{
  final _time = Constants.time.obs;
  final _distance = Constants.distance.obs;
  final _unit = Constants.defaultUnit.obs;
  final _location = ''.obs;
  final _latitude = 0.0.obs;
  final _longitude = 0.0.obs;

  int get time => _time.value;
  set time(int value) => _time.value = value;

  int get distance => _distance.value;
  set distance(int value) => _distance.value = value;

  int get unit => _unit.value;
  set unit(int value) => _unit.value = value;

  String get location => _location.value;
  set location(String value) => _location.value = value;

  double get latitude => _latitude.value;
  set latitude(double value) => _latitude.value = value;

  double get longitude => _longitude.value;
  set longitude(double value) => _longitude.value = value;
}
