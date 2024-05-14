import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bonsplans/configs/routes.dart';

class GoogleController extends GetxController{
  final _profile = {}.obs;

  Map? get profile => _profile.value;
  set profile(Map? value) => _profile.value = value!;
}
