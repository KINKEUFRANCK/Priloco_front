import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/formatter.dart';
import 'package:bonsplans/utils/api.dart';

class RegistrationVerify2Screen extends StatefulWidget {
  static String id = Routes.registration_verify_2;
  final String title;

  const RegistrationVerify2Screen({Key? key, required this.title}) : super(key: key);

  @override
  State<RegistrationVerify2Screen> createState() => _RegistrationVerify2ScreenState();
}

class _RegistrationVerify2ScreenState extends State<RegistrationVerify2Screen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController code1Controller = TextEditingController();
  TextEditingController code2Controller = TextEditingController();
  TextEditingController code3Controller = TextEditingController();
  TextEditingController code4Controller = TextEditingController();
  TextEditingController code5Controller = TextEditingController();
  bool _isFilter = false;
  bool _isSubmit = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String? email = null;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          email = Get.arguments?['email'];
        } on Exception catch (e, s) {
          print('totototototo exception: ${e.toString()}');
        }
        setState(() {
          _isFilter = true;
        });
      }
    });

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
                                "Confirmation de votre compte ?".tr,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: size.height * 0.05, width: size.width * 0.08),
                            Center(
                              child: Container(
                                width: 260,
                                child: Text(
                                  "Un code de confirmation a été envoyé à votre adresse e-mail.".tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Container(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Entrez le code *".tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingFormatter(max: 1),
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: code1Controller,
                                    textAlign: TextAlign.center,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingFormatter(max: 1),
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: code2Controller,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingFormatter(max: 1),
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: code3Controller,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingFormatter(max: 1),
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: code4Controller,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingFormatter(max: 1),
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: code5Controller,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (!_isSubmit) {
                                          setState(() {
                                            _isSubmit = true;
                                          });
                                          try {
                                            var code = '${code1Controller.text}${code2Controller.text}${code3Controller.text}${code4Controller.text}${code5Controller.text}';
                                            http.Response response = await verifyConfirmRegistrationUser(email!, code);
                                            var body = json.decode(utf8.decode(response.bodyBytes));
                                            switch (response.statusCode) {
                                              case 200:
                                                code1Controller.clear();
                                                code2Controller.clear();
                                                code3Controller.clear();
                                                code4Controller.clear();
                                                code5Controller.clear();
                                                Flushbar(
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 28.0,
                                                    color: Colors.blue,
                                                  ),
                                                  duration: Duration(seconds: 3),
                                                  leftBarIndicatorColor: Colors.blue,
                                                  flushbarPosition: FlushbarPosition.TOP,
                                                  title: 'Confirmation de votre compte ?'.tr,
                                                  message: 'La confirmation du compte a été effectuée',
                                                )..show(context);
                                                await Future.delayed(const Duration(seconds: 3));
                                                Get.toNamed(Routes.registration_verify_3);
                                                break;
                                              case 400:
                                                if (body['errors'].containsKey('detail')) {
                                                  Flushbar(
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      size: 28.0,
                                                      color: Colors.blue,
                                                    ),
                                                    duration: Duration(seconds: 3),
                                                    leftBarIndicatorColor: Colors.blue,
                                                    flushbarPosition: FlushbarPosition.TOP,
                                                    title: 'Confirmation de votre compte ?'.tr,
                                                    message: 'Code incorrect',
                                                  )..show(context);
                                                } else if (body['errors'].containsKey('old_password')) {
                                                  Flushbar(
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      size: 28.0,
                                                      color: Colors.blue,
                                                    ),
                                                    duration: Duration(seconds: 3),
                                                    leftBarIndicatorColor: Colors.blue,
                                                    flushbarPosition: FlushbarPosition.TOP,
                                                    title: 'Confirmation de votre compte ?'.tr,
                                                    message: 'Code incorrect',
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
                                                      title: 'Confirmation de votre compte ?'.tr,
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
                                                      title: 'Confirmation de votre compte ?'.tr,
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
                                                      title: 'Confirmation de votre compte ?'.tr,
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
                                                  title: 'Confirmation de votre compte ?'.tr,
                                                  message: "Une erreur a été rencontrée lors de la réinitialisation du mot de passe",
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
                                              title: 'Confirmation de votre compte ?'.tr,
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
                                          title: 'Confirmation de votre compte ?'.tr,
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
                                      _isSubmit ? "Confirmer le compte...".tr : "Confirmer le compte".tr,
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
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 1.0,
                                      side: BorderSide(width: 1, color: ColorExtension.toColor('#FF914D')),
                                      backgroundColor: ColorExtension.toColor('#FFFFFF'),
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                      padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18)
                                    ),
                                    child: Text(
                                      "Annuler".tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorExtension.toColor('#FF914D'),
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
