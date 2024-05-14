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

class ContactServiceScreen extends StatefulWidget {
  static String id = Routes.contactservice;
  final String title;

  const ContactServiceScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<ContactServiceScreen> createState() => _ContactServiceScreenState();
}

class _ContactServiceScreenState extends State<ContactServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController contentController = TextEditingController();
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
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            iconSize: 24.0,
                            color: ColorExtension.toColor('#9E9E9E'),
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              FontAwesomeIcons.arrowLeft,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Service client".tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            iconSize: 24.0,
                            color: Colors.transparent,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.filter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 2),
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Vous avez une préoccupation ? Laissez un message à notre service client qui vous répondra dans le plus bref délais.".tr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorExtension.toColor('#ff914d'),
                    ),
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
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              minLines: 6,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: contentController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer votre message'.tr;
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Entrer votre message".tr,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
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
                                        if (!_isSubmit) {
                                          setState(() {
                                            _isSubmit = true;
                                          });
                                          try {
                                            http.Response response = await createContactService(token, tokenRefresh, content: contentController.text);
                                            var body = json.decode(utf8.decode(response.bodyBytes));
                                            switch (response.statusCode) {
                                              case 200:
                                                contentController.clear();
                                                Flushbar(
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 28.0,
                                                    color: Colors.blue,
                                                  ),
                                                  duration: Duration(seconds: 3),
                                                  leftBarIndicatorColor: Colors.blue,
                                                  flushbarPosition: FlushbarPosition.TOP,
                                                  title: 'Service client'.tr,
                                                  message: 'Envoie de votre message a été effectué',
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
                                                  title: 'Service client'.tr,
                                                  message: "Une erreur a été rencontrée lors de l'envoie de votre message",
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
                                              title: 'Service client'.tr,
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
                                          title: 'Service client'.tr,
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
                                      _isSubmit ? "Envoyer...".tr : "Envoyer".tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
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
