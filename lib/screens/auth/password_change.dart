import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/configs/constants.dart';

class PasswordChangeScreen extends StatefulWidget {
  static String id = Routes.password_change;
  final String title;

  const PasswordChangeScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _oldPasswordVisible = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isSubmit = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      // appBar: AppBar(
        // title: Text(widget.title),
      // ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: topHeight + 10, bottom: topHeight + 10),
            child: Column(
              children: <Widget>[
                Container(
                  width: size.width,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            iconSize: 28.0,
                            color: ColorExtension.toColor('#9E9E9E'),
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              FontAwesomeIcons.close,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 120,
                              ),
                            ),
                            Center(
                              child: Text(
                                "Modifier le mot de passe".tr,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: oldPasswordController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer votre mot de passe'.tr;
                                }
                                return null;
                              },
                              obscureText: _oldPasswordVisible ? false : true,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Entrer le mot de passe *".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.lock,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                suffixIcon: IconButton(
                                  iconSize: 24.0,
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _oldPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _oldPasswordVisible = !_oldPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer votre nouveau mot de passe'.tr;
                                }
                                return null;
                              },
                              obscureText: _passwordVisible ? false : true,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Entrer le nouveau mot de passe *".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.lock,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                suffixIcon: IconButton(
                                  iconSize: 24.0,
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez confirmer votre nouveau mot de passe'.tr;
                                }
                                return null;
                              },
                              obscureText: _confirmPasswordVisible ? false : true,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Confirmer le nouveau mot de passe *".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.lock,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                suffixIcon: IconButton(
                                  iconSize: 24.0,
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _confirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _confirmPasswordVisible = !_confirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (passwordController.text == confirmPasswordController.text) {
                                          if (!_isSubmit) {
                                            setState(() {
                                              _isSubmit = true;
                                            });
                                            try {
                                              http.Response response = await changePasswordUser(token, tokenRefresh, old_password: oldPasswordController.text, password: passwordController.text, password2: confirmPasswordController.text);
                                              var body = json.decode(utf8.decode(response.bodyBytes));
                                              switch (response.statusCode) {
                                                case 200:
                                                  oldPasswordController.clear();
                                                  passwordController.clear();
                                                  confirmPasswordController.clear();
                                                  Flushbar(
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      size: 28.0,
                                                      color: Colors.blue,
                                                    ),
                                                    duration: Duration(seconds: 3),
                                                    leftBarIndicatorColor: Colors.blue,
                                                    flushbarPosition: FlushbarPosition.TOP,
                                                    title: 'Modifier le mot de passe'.tr,
                                                    message: 'Modification du mot de passe a été effectué',
                                                  )..show(context);
                                                  await Future.delayed(const Duration(seconds: 3));
                                                  Get.toNamed(Routes.menu);
                                                  break;
                                                case 400:
                                                  if (body['errors'].containsKey('old_password')) {
                                                    Flushbar(
                                                      icon: Icon(
                                                        Icons.info_outline,
                                                        size: 28.0,
                                                        color: Colors.blue,
                                                      ),
                                                      duration: Duration(seconds: 3),
                                                      leftBarIndicatorColor: Colors.blue,
                                                      flushbarPosition: FlushbarPosition.TOP,
                                                      title: 'Modifier le mot de passe'.tr,
                                                      message: 'Mot de passe incorrect',
                                                    )..show(context);
                                                  } else if (body['errors'].containsKey('password')) {
                                                    if (body['errors']['password'][0].contains('at least 8 characters') || body['errors']['password'][0].contains('at least 1 capital letter') || body['errors']['password'][0].contains('at least 1 special character')) {
                                                      Flushbar(
                                                        icon: Icon(
                                                          Icons.info_outline,
                                                          size: 28.0,
                                                          color: Colors.blue,
                                                        ),
                                                        duration: Duration(seconds: 3),
                                                        leftBarIndicatorColor: Colors.blue,
                                                        flushbarPosition: FlushbarPosition.TOP,
                                                        title: 'Modifier le mot de passe'.tr,
                                                        message: "Nouveau mot de passe doit contenir au moins 8 caractères, une majuscule, et un caractère spécial",
                                                      )..show(context);
                                                    } else if (body['errors']['password'][0].contains("Password fields didn't match.")) {
                                                      Flushbar(
                                                        icon: Icon(
                                                          Icons.info_outline,
                                                          size: 28.0,
                                                          color: Colors.blue,
                                                        ),
                                                        duration: Duration(seconds: 3),
                                                        leftBarIndicatorColor: Colors.blue,
                                                        flushbarPosition: FlushbarPosition.TOP,
                                                        title: 'Modifier le mot de passe'.tr,
                                                        message: 'Nouveau mot de passe incorrect',
                                                      )..show(context);
                                                    } else {
                                                      Flushbar(
                                                        icon: Icon(
                                                          Icons.info_outline,
                                                          size: 28.0,
                                                          color: Colors.blue,
                                                        ),
                                                        duration: Duration(seconds: 3),
                                                        leftBarIndicatorColor: Colors.blue,
                                                        flushbarPosition: FlushbarPosition.TOP,
                                                        title: 'Modifier le mot de passe'.tr,
                                                        message: 'Nouveau mot de passe est déjà utilisé',
                                                      )..show(context);
                                                    }
                                                  }
                                                  break;
                                                default:
                                                  Flushbar(
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      size: 28.0,
                                                      color: Colors.blue,
                                                    ),
                                                    duration: Duration(seconds: 3),
                                                    leftBarIndicatorColor: Colors.blue,
                                                    flushbarPosition: FlushbarPosition.TOP,
                                                    title: 'Modifier le mot de passe'.tr,
                                                    message: "Une erreur a été rencontrée lors de la modification du mot de passe",
                                                  )..show(context);
                                                  break;
                                              }
                                            } on Exception catch (e, s) {
                                              print('totototototo exception: ${e.toString()}');

                                              Flushbar(
                                                icon: Icon(
                                                  Icons.info_outline,
                                                  size: 28.0,
                                                  color: Colors.blue,
                                                ),
                                                duration: Duration(seconds: 3),
                                                leftBarIndicatorColor: Colors.blue,
                                                flushbarPosition: FlushbarPosition.TOP,
                                                title: 'Modifier le mot de passe'.tr,
                                                message:  e.toString(),
                                              )..show(context);
                                            }
                                            setState(() {
                                              _isSubmit = false;
                                            });
                                          }
                                        } else {
                                          Flushbar(
                                            icon: Icon(
                                              Icons.info_outline,
                                              size: 28.0,
                                              color: Colors.blue,
                                            ),
                                            duration: Duration(seconds: 3),
                                            leftBarIndicatorColor: Colors.blue,
                                            flushbarPosition: FlushbarPosition.TOP,
                                            title: 'Modifier le mot de passe'.tr,
                                            message: 'Confirmation du mot de passe incorrecte',
                                          )..show(context);
                                        }
                                      } else {
                                        Flushbar(
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 28.0,
                                            color: Colors.blue,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue,
                                          flushbarPosition: FlushbarPosition.TOP,
                                          title: 'Modifier le mot de passe'.tr,
                                          message: 'Veuillez remplir les champs'.tr,
                                        )..show(context);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 1.0,
                                      backgroundColor: ColorExtension.toColor('#FF914D'),
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                      padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18)
                                    ),
                                    child: Text(
                                      _isSubmit ? "Modifier le mot de passe...".tr : "Modifier le mot de passe".tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorExtension.toColor('#FFFFFF'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
