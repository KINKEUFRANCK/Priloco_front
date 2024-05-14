import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/utils/google_auth.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/controllers/login.dart';
import 'package:bonsplans/controllers/location.dart';
import 'package:bonsplans/controllers/google.dart';

class LoginScreen extends StatefulWidget {
  static String id = Routes.login;
  final String title;

  const LoginScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isFilter = false;
  bool _isSubmit = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final loginControl = Get.put(LoginController());
    final locationControl = Get.put(LocationController());
    final googleController = Get.put(GoogleController());
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;
    final item = Get.arguments?['index'];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          googleController.profile = {};
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
                                "Connexion".tr,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: size.height * 0.05, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer votre e-mail'.tr;
                                } else if (!EmailValidator.validate(value)) {
                                  return 'Veuillez entrer un e-mail valide'.tr;
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Entrer l'adresse e-mail *".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 2),
                                  child: Icon(FontAwesomeIcons.envelope,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer votre mot de passe'.tr;
                                }
                                return null;
                              },
                              obscureText: _passwordVisible ? false : true,
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
                            Container(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.password_reset_1);
                                    },
                                    child: Text("Mot de passe oublié ?".tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: ColorExtension.toColor('#F69723'),
                                      ),
                                    ),
                                  ),
                                ],
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
                                        if (!_isSubmit) {
                                          setState(() {
                                            _isSubmit = true;
                                          });
                                          try {
                                            http.Response responseLogin = await loginUser(emailController.text, passwordController.text);
                                            var bodyLogin = json.decode(utf8.decode(responseLogin.bodyBytes));
                                            switch (responseLogin.statusCode) {
                                              case 200:
                                                http.Response responseUser = await retrieveUser(bodyLogin['access'], bodyLogin['refresh']);
                                                var bodyUser = json.decode(utf8.decode(responseUser.bodyBytes));

                                                if (bodyUser['verified']) {
                                                  await storage.write(key: 'access', value: bodyLogin['access']);
                                                  await storage.write(key: 'refresh', value: bodyLogin['refresh']);
                                                  emailController.clear();
                                                  passwordController.clear();
                                                  Flushbar(
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      size: 28.0,
                                                      color: Colors.blue,
                                                    ),
                                                    duration: Duration(seconds: 3),
                                                    leftBarIndicatorColor: Colors.blue,
                                                    flushbarPosition: FlushbarPosition.TOP,
                                                    title: 'Connexion'.tr,
                                                    message: 'Merci de vous être connecté',
                                                  )..show(context);
                                                  await Future.delayed(const Duration(seconds: 3));
                                                  if (item != null) {
                                                    Get. offAllNamed(loginControl.route, arguments: {'index': item},);
                                                  } else {
                                                    Get. offAllNamed(loginControl.route);
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
                                                    title: 'Connexion'.tr,
                                                    message: 'Le code de confirmation de votre compte doit être validé dans votre boîte mail',
                                                  )..show(context);
                                                }
                                                break;
                                              case 400:
                                                Flushbar(
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 28.0,
                                                    color: Colors.blue,
                                                  ),
                                                  duration: Duration(seconds: 3),
                                                  leftBarIndicatorColor: Colors.blue,
                                                  flushbarPosition: FlushbarPosition.TOP,
                                                  title: 'Connexion'.tr,
                                                  message: 'Adresse e-mail ou mot de passe incorrect',
                                                )..show(context);
                                                break;
                                              case 401:
                                                Flushbar(
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 28.0,
                                                    color: Colors.blue,
                                                  ),
                                                  duration: Duration(seconds: 3),
                                                  leftBarIndicatorColor: Colors.blue,
                                                  flushbarPosition: FlushbarPosition.TOP,
                                                  title: 'Connexion'.tr,
                                                  message: 'Adresse e-mail ou mot de passe incorrect',
                                                )..show(context);
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
                                                  title: 'Connexion'.tr,
                                                  message: "Une erreur a été rencontrée lors de la connexion",
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
                                              title: 'Connexion'.tr,
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
                                          title: 'Connexion'.tr,
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
                                      _isSubmit ? "Connexion...".tr : "Connexion".tr,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: 60,
                                  child: Divider(
                                    thickness: 0.5,
                                    color: ColorExtension.toColor('#DDDDDD'),
                                  ),
                                ),
                                Text("ou continuer avec".tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  child: Divider(
                                    thickness: 0.5,
                                    color: ColorExtension.toColor('#DDDDDD'),
                                  ),
                                ),
                              ],
                            ),
                            if (!Platform.isIOS) ...[
                              SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: Image.asset(
                                        'assets/images/google.png',
                                      ),
                                      onPressed: () async {
                                        if (!_isSubmit) {
                                          setState(() {
                                            _isSubmit = true;
                                          });
                                          try {
                                            var (UserCredential userCredential, dynamic accountData) = await signInWithGoogle();

                                            if (userCredential.additionalUserInfo != null) {
                                              googleController.profile = userCredential.additionalUserInfo!.profile;

                                              if (!googleController.profile!.containsKey('sub')) {
                                                googleController.profile!['sub'] = googleController.profile!['id'];
                                              }

                                              print('totototototo profile: ${googleController.profile}');

                                              http.Response responseLogin = await loginGoogleUser(googleController.profile);
                                              var bodyLogin = json.decode(utf8.decode(responseLogin.bodyBytes));
                                              switch (responseLogin.statusCode) {
                                                case 200:
                                                  http.Response responseUser = await retrieveUser(bodyLogin['access'], bodyLogin['refresh']);
                                                  var bodyUser = json.decode(utf8.decode(responseUser.bodyBytes));

                                                  await storage.write(key: 'access', value: bodyLogin['access']);
                                                  await storage.write(key: 'refresh', value: bodyLogin['refresh']);
                                                  emailController.clear();
                                                  passwordController.clear();
                                                  Flushbar(
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      size: 28.0,
                                                      color: Colors.blue,
                                                    ),
                                                    duration: Duration(seconds: 3),
                                                    leftBarIndicatorColor: Colors.blue,
                                                    flushbarPosition: FlushbarPosition.TOP,
                                                    title: 'Connexion'.tr,
                                                    message: 'Merci de vous être connecté',
                                                  )..show(context);
                                                  await Future.delayed(const Duration(seconds: 3));
                                                  if (item != null) {
                                                    Get. offAllNamed(loginControl.route, arguments: {'index': item},);
                                                  } else {
                                                    Get. offAllNamed(loginControl.route);
                                                  }
                                                  break;
                                                default:
                                                  Get.toNamed(Routes.register);
                                                  break;
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
                                                title: 'Connexion'.tr,
                                                message: "Une erreur a été rencontrée lors de la connexion avec Google",
                                              )..show(context);
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
                                              title: 'Connexion'.tr,
                                              message:  e.toString(),
                                            )..show(context);
                                          }
                                          setState(() {
                                            _isSubmit = false;
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 1.0,
                                        backgroundColor: ColorExtension.toColor('#FFFFFF'),
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                        padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18)
                                      ),
                                      label: Text(
                                        _isSubmit ? "Google...".tr : "Google",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: ColorExtension.toColor('#9E9E9E'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(width: size.width * 0.03),
                                  // Expanded(
                                  //   child: ElevatedButton.icon(
                                  //     icon: Icon(
                                  //       FontAwesomeIcons.facebook,
                                  //       size: 24.0,
                                  //       color: ColorExtension.toColor('#FFFFFF'),
                                  //     ),
                                  //     onPressed: () {},
                                  //     style: ElevatedButton.styleFrom(
                                  //       elevation: 1.0,
                                  //       backgroundColor: ColorExtension.toColor('#FF914D'),
                                  //       shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(20)),
                                  //       padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18)
                                  //     ),
                                  //     label: Text(
                                  //       "Facebook",
                                  //       overflow: TextOverflow.ellipsis,
                                  //       style: TextStyle(
                                  //         fontSize: 14,
                                  //         color: ColorExtension.toColor('#FFFFFF'),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (item != null) {
                                      if (item == 4) {
                                        Get.back();
                                      } else {
                                        Get.until((route) => route.settings.name == Routes.menu);
                                        Get.toNamed(Routes.register, arguments: {'index': item},);
                                      }
                                    } else {
                                      Get.until((route) => route.settings.name == Routes.menu);
                                      Get.toNamed(Routes.register);
                                    }
                                  },
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    text: TextSpan(children: <TextSpan> [
                                      TextSpan(
                                        text: "Vous n'êtes pas encore inscrit ?\n".tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ColorExtension.toColor('#000000'),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Créer un compte ici".tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ColorExtension.toColor('#F69723'),
                                        ),
                                      ),
                                    ]),
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
