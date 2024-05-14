import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bonsplans/configs/routes.dart';

class PostController extends GetxController{
  final _post = {}.obs;

  Map get post => _post.value;
  set post(Map value) => _post.value = value;
}
