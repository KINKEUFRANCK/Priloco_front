import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bonsplans/configs/routes.dart';

class LoginController extends GetxController{
  final _authenticated = false.obs;
  final _route = Routes.menu.obs;
  final _role = 3.obs;

  bool get authenticated => _authenticated.value;
  set authenticated(bool value) => _authenticated.value = value;

  String get route => _route.value;
  set route(String value) => _route.value = value;

  int get role => _role.value;
  set role(int value) => _role.value = value;
}
