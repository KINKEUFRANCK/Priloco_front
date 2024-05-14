import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';

class RegistrationVerify3Screen extends StatefulWidget {
  static String id = Routes.registration_verify_3;
  final String title;

  const RegistrationVerify3Screen({Key? key, required this.title}) : super(key: key);

  @override
  State<RegistrationVerify3Screen> createState() => _RegistrationVerify3ScreenState();
}

class _RegistrationVerify3ScreenState extends State<RegistrationVerify3Screen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
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
                              SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Félicitations".tr,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Votre compte a été confirmé avec succès".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.until((route) => route.settings.name == Routes.register);
                                        Get.offAndToNamed(Routes.login);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 1.0,
                                        backgroundColor: ColorExtension.toColor('#FF914D'),
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                        padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18)
                                      ),
                                      child: Text(
                                        "Se connecter".tr,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
