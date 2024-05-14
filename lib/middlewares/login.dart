import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/controllers/login.dart';

class LoginMiddleware extends GetMiddleware {
  // priority this value the smaller the better
  @override
  int? priority = 0;
  LoginMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    final loginControl = Get.put(LoginController());
    final item = Get.arguments?['index'];

    if (loginControl.authenticated) {
      return null;
    } else {
      if (item != null) {
        return RouteSettings(name: Routes.login, arguments: {'index': item},);
      } else {
        return RouteSettings(name: Routes.login);
      }
    }
  }
}
