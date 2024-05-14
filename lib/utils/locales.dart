import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

Future<void> updateLocale(String locale) async {
  Get.updateLocale(Locale(locale));
}
