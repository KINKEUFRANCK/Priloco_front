import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/dialog.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/controllers/login.dart';
import 'package:bonsplans/controllers/location.dart';
import 'package:bonsplans/configs/constants.dart';

import 'package:bonsplans/components/account.dart';

class AccountScreen extends StatefulWidget {
  static String id = Routes.account;
  final String title;
  final Function(int) functionCallback;

  const AccountScreen({Key? key, required this.title, required this.functionCallback}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState(functionCallback: functionCallback);
}

class _AccountScreenState extends State<AccountScreen> {
  final Function(int) functionCallback;

  _AccountScreenState({required this.functionCallback});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final loginControl = Get.put(LoginController());
    final locationControl = Get.put(LocationController());
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      floatingActionButton: !loginControl.authenticated ? FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.register);
        },
        backgroundColor: ColorExtension.toColor('#FF914D'),
        child: const Icon(Icons.person_add_alt_1_outlined),
      ) : null,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: topHeight + 10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (loginControl.authenticated) ...[
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: ColorExtension.toColor('#ECEFF4'),
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: ColorExtension.toColor('#95989A'),
                                child: Text(
                                  authProvider.data['first_name'] != null ? authProvider.data['first_name'].substring(0, 2).trim().toUpperCase() : "PL",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: ColorExtension.toColor('#FFFFFF'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: ColorExtension.toColor('#ECEFF4'),
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: ColorExtension.toColor('#95989A'),
                                child: Text(
                                  "PL",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: ColorExtension.toColor('#FFFFFF'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: <Widget>[
                              Text('${authProvider.data['first_name'] != null ? authProvider.data['first_name'] : ""} ${authProvider.data['last_name'] != null ? authProvider.data['last_name'].toString() : ""}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('${authProvider.data['email'] != null ? authProvider.data['email'].toString() : ""}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: ColorExtension.toColor('#FF914D'),
                          ),
                          child: Text("Mes paramètres".tr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorExtension.toColor('#FFFFFF'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  if (!Platform.isIOS) ...[
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(Routes.location);
                                      },
                                      child: AccountList(item: new Account(Icons.my_location, 'Ma localisation'.tr)),
                                    ),
                                  ],
                                  GestureDetector(
                                    onTap: () {
                                        Get.toNamed(Routes.language);
                                      },
                                    child: AccountList(item: new Account(Icons.language, 'Langue'.tr)),
                                  ),
                                  if (loginControl.authenticated) ...[
                                    GestureDetector(
                                      onTap: () {
                                          Get.toNamed(Routes.password_change);
                                        },
                                      child: AccountList(item: new Account(Icons.lock, 'Modifier le mot de passe'.tr)),
                                    ),
                                  ],
                                  GestureDetector(
                                    onTap: () {
                                        Get.toNamed(Routes.contactservice);
                                      },
                                    child: AccountList(item: new Account(Icons.help_outline, 'Service client'.tr)),
                                  ),
                                  if (loginControl.authenticated && loginControl.role < 3) ...[
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(Routes.post_create_step_1);
                                      },
                                      child: AccountList(item: new Account(Icons.share, 'Publier une offre'.tr)),
                                    ),
                                  
                                  GestureDetector(
                                    onTap: () {
                                        Get.toNamed(Routes.favoritecategory);
                                      },
                                    child: AccountList(item: new Account(Icons.check_circle, 'Préférences'.tr)),
                                  ),
                                  ],
                                  GestureDetector(
                                    onTap: () {
                                        Get.toNamed(Routes.survey_list);
                                      },
                                    child: AccountList(item: new Account(Icons.speaker_notes, 'Sondages'.tr)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                        Get.toNamed(Routes.about);
                                      },
                                    child: AccountList(item: new Account(Icons.info, 'A propos de Priloco'.tr)),
                                  ),
                                  if (loginControl.authenticated) ...[
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(Routes.logout);
                                      },
                                      child: AccountList(item: new Account(Icons.logout, 'Déconnexion'.tr)),
                                    ),
                                  ] else ...[
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(Routes.login);
                                      },
                                      child: AccountList(item: new Account(Icons.login, 'Connexion'.tr)),
                                    ),
                                  ],
                                  if (loginControl.authenticated) ...[
                                    SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                var confirmDestroy = false;
                                                await confirmDestroyUser(context, (opt) {
                                                  confirmDestroy = opt;
                                                });

                                                if (confirmDestroy == true) {
                                                  http.Response responseUser = await destroyUser(token, tokenRefresh);
                                                  var bodyUser = json.decode(utf8.decode(responseUser.bodyBytes));
                                                  switch (responseUser.statusCode) {
                                                    case 200:
                                                      Flushbar(
                                                        icon: Icon(
                                                          Icons.info_outline,
                                                          size: 28.0,
                                                          color: Colors.blue,
                                                        ),
                                                        duration: Duration(seconds: 3),
                                                        leftBarIndicatorColor: Colors.blue,
                                                        flushbarPosition: FlushbarPosition.TOP,
                                                        title: 'Supprimer le compte'.tr,
                                                        message: "La suppression du compte a été effectué",
                                                      )..show(context);
                                                      await Future.delayed(const Duration(seconds: 3));
                                                      Get.toNamed(Routes.logout);
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
                                                        title: 'Supprimer le compte'.tr,
                                                        message: "Une erreur a été rencontrée lors de la suppression du compte",
                                                      )..show(context);
                                                      break;
                                                  }
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
                                                "Supprimer le compte".tr,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorExtension.toColor('#FFFFFF'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 2.0,
                    width: size.width * 0.95,
                    child: CustomPaint(painter: DashedLinePainter(),)
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

/* class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 10, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = ColorExtension.toColor('#DDDDDD')
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} */

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorExtension.toColor('#DDDDDD')
      ..strokeWidth = 1;

    Offset startX = Offset(0, size.height / 2);
    Offset endX = Offset(size.width, size.height / 2);

    canvas.drawLine(startX, endX, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
