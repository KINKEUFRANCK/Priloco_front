import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/controllers/login.dart';
import 'package:bonsplans/controllers/location.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/controllers/google.dart';

class RegisterScreen extends StatefulWidget {
  static String id = Routes.register;
  final String title;

  const RegisterScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool _isFilter = false;
  bool _isSubmit = false;
  int? _selectedRole = 3;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool? _checkPolicy = false;

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
          emailController.text = googleController.profile!.isNotEmpty ? googleController.profile!['email'].toString() : '';
          firstNameController.text = googleController.profile!.isNotEmpty ? googleController.profile!['given_name'].toString() : '';
          lastNameController.text = googleController.profile!.isNotEmpty ? googleController.profile!['family_name'].toString() : '';
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
                                "Inscription".tr,
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
                              keyboardType: TextInputType.text,
                              controller: firstNameController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer votre prénom'.tr;
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Entrer le prénom *".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.user,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: lastNameController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Entrer le nom".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.user,),
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
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez confirmer votre mot de passe'.tr;
                                }
                                return null;
                              },
                              obscureText: _confirmPasswordVisible ? false : true,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Confirmer le mot de passe *".tr,
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
                                  child: RadioListTile<int>(
                                    title: Text(
                                      Constants.role[2].tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: ColorExtension.toColor('#000000'),
                                      ),
                                    ),
                                    value: 3, 
                                    groupValue: _selectedRole, 
                                    onChanged: (int? value) {
                                      setState(() {
                                        _selectedRole = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<int>(
                                    title: Text(
                                      Constants.role[1].tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: ColorExtension.toColor('#000000'),
                                      ),
                                    ),
                                    value: 2, 
                                    groupValue: _selectedRole, 
                                    onChanged: (int? value) {
                                      setState(() {
                                        _selectedRole = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            CheckboxListTile(
                              value: _checkPolicy,
                              controlAffinity: ListTileControlAffinity.leading, //checkbox at left
                              onChanged: (bool? value) {  
                                setState(() {
                                  _checkPolicy = value;
                                });
                              },
                              title: RichText(
                                textAlign: TextAlign.center,
                                softWrap: true,
                                text: TextSpan(children: <TextSpan> [
                                  TextSpan(
                                    text: "J'accepte *\n".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ColorExtension.toColor('#000000'),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "les conditions générales de \n".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ColorExtension.toColor('#F69723'),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "vente et d'utilisation".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ColorExtension.toColor('#F69723'),
                                    ),
                                  ),
                                ]),
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
                                          if (_checkPolicy == true) {
                                            if (!_isSubmit) {
                                              setState(() {
                                                _isSubmit = true;
                                              });
                                              try {
                                                if (googleController.profile!.isNotEmpty) {
                                                  http.Response response = await registerGoogleUser(passwordController.text, _selectedRole!, firstNameController.text, lastNameController.text, googleController.profile);
                                                  var body = json.decode(utf8.decode(response.bodyBytes));
                                                  switch (response.statusCode) {
                                                    case 200:
                                                      http.Response responseUser = await retrieveUser(body['access'], body['refresh']);
                                                      var bodyUser = json.decode(utf8.decode(responseUser.bodyBytes));
                                                      emailController.clear();
                                                      passwordController.clear();
                                                      confirmPasswordController.clear();
                                                      firstNameController.clear();
                                                      lastNameController.clear();
                                                      Flushbar(
                                                        icon: Icon(
                                                          Icons.info_outline,
                                                          size: 28.0,
                                                          color: Colors.blue,
                                                        ),
                                                        duration: Duration(seconds: 3),
                                                        leftBarIndicatorColor: Colors.blue,
                                                        flushbarPosition: FlushbarPosition.TOP,
                                                        title: 'Inscription'.tr,
                                                        message: 'La création du compte a été effectuée',
                                                      )..show(context);
                                                      await Future.delayed(const Duration(seconds: 3));
                                                      if (item != null) {
                                                        Get.until((route) => route.settings.name == Routes.menu);
                                                        Get.toNamed(Routes.login, arguments: {'index': item},);
                                                      } else {
                                                        Get.until((route) => route.settings.name == Routes.menu);
                                                        Get.toNamed(Routes.login);
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
                                                        title: 'Inscription'.tr,
                                                        message: "Une erreur a été rencontrée lors de la création du compte",
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
                                                        title: 'Inscription'.tr,
                                                        message: "Une erreur a été rencontrée lors de la création du compte",
                                                      )..show(context);
                                                      break;
                                                  }
                                                } else {
                                                  http.Response response = await registerUser(emailController.text, passwordController.text, _selectedRole!, firstNameController.text, lastNameController.text);
                                                  var body = json.decode(utf8.decode(response.bodyBytes));
                                                  switch (response.statusCode) {
                                                    case 201:
                                                      emailController.clear();
                                                      passwordController.clear();
                                                      confirmPasswordController.clear();
                                                      firstNameController.clear();
                                                      lastNameController.clear();
                                                      Flushbar(
                                                        icon: Icon(
                                                          Icons.info_outline,
                                                          size: 28.0,
                                                          color: Colors.blue,
                                                        ),
                                                        duration: Duration(seconds: 3),
                                                        leftBarIndicatorColor: Colors.blue,
                                                        flushbarPosition: FlushbarPosition.TOP,
                                                        title: 'Inscription'.tr,
                                                        message: 'La création du compte a été effectuée, vous recevrez dans votre boîte mail un code de confirmation de votre compte',
                                                      )..show(context);
                                                      await Future.delayed(const Duration(seconds: 3));
                                                      Get.toNamed(Routes.registration_verify_2, arguments: {'email': emailController.text},);
                                                      break;
                                                    case 400:
                                                      if (body['errors'].containsKey('email')) {
                                                        Flushbar(
                                                          icon: Icon(
                                                            Icons.info_outline,
                                                            size: 28.0,
                                                            color: Colors.blue,
                                                          ),
                                                          duration: Duration(seconds: 3),
                                                          leftBarIndicatorColor: Colors.blue,
                                                          flushbarPosition: FlushbarPosition.TOP,
                                                          title: 'Inscription'.tr,
                                                          message: 'Adresse e-mail est déjà utilisée',
                                                        )..show(context);
                                                      } else if (body['errors'].containsKey('password1')) {
                                                        if (body['errors']['password1'][0].contains('at least 8 characters') || body['errors']['password1'][0].contains('at least 1 capital letter') || body['errors']['password1'][0].contains('at least 1 special character')) {
                                                          Flushbar(
                                                            icon: Icon(
                                                              Icons.info_outline,
                                                              size: 28.0,
                                                              color: Colors.blue,
                                                            ),
                                                            duration: Duration(seconds: 3),
                                                            leftBarIndicatorColor: Colors.blue,
                                                            flushbarPosition: FlushbarPosition.TOP,
                                                            title: 'Inscription'.tr,
                                                            message: "Mot de passe doit contenir au moins 8 caractères, une majuscule, et un caractère spécial",
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
                                                            title: 'Inscription'.tr,
                                                            message: "Mot de passe n'est pas valide",
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
                                                        title: 'Inscription'.tr,
                                                        message: "Une erreur a été rencontrée lors de la création du compte",
                                                      )..show(context);
                                                      break;
                                                  }
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
                                                  title: 'Inscription'.tr,
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
                                              title: 'Inscription'.tr,
                                              message: "Les conditions générales de vente et d'utilisation doivent être acceptées",
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
                                            title: 'Inscription'.tr,
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
                                          title: 'Inscription'.tr,
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
                                      _isSubmit ? "Inscription...".tr : "Inscription".tr,
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
                                GestureDetector(
                                  onTap: () {
                                    if (item != null) {
                                      if (item == 4) {
                                        Get.back();
                                      } else {
                                        Get.until((route) => route.settings.name == Routes.menu);
                                        Get.toNamed(Routes.login, arguments: {'index': item},);
                                      }
                                    } else {
                                      Get.until((route) => route.settings.name == Routes.menu);
                                      Get.toNamed(Routes.login);
                                    }
                                  },
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    text: TextSpan(children: <TextSpan> [
                                      TextSpan(
                                        text: "Vous avez déjà un compte ?\n".tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ColorExtension.toColor('#000000'),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Connectez-vous ici".tr,
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
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.registration_verify_1);
                                  },
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    text: TextSpan(children: <TextSpan> [
                                      TextSpan(
                                        text: "Vous n'avez pas reçu le code de \n".tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ColorExtension.toColor('#000000'),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "confirmation de votre compte ?\n".tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ColorExtension.toColor('#000000'),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Renvoyer le code ici".tr,
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
