import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/providers/survey.dart';
import 'package:bonsplans/components/survey.dart';
import 'package:bonsplans/controllers/survey.dart';
import 'package:bonsplans/configs/constants.dart';

class SurveyCreateStep3Screen extends StatefulWidget {
  static String id = Routes.survey_create_step_3;
  final String title;

  const SurveyCreateStep3Screen({Key? key, required this.title}) : super(key: key);

  @override
  State<SurveyCreateStep3Screen> createState() => _SurveyCreateStep3ScreenState();
}

class _SurveyCreateStep3ScreenState extends State<SurveyCreateStep3Screen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> listResponse = {};

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final surveyController = Get.put(SurveyController());
    final surveyProvider = Provider.of<SurveyProvider>(context);
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
                          child: Text(surveyProvider.survey['title'],
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
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            size: 24.0,
                            color: ColorExtension.toColor('#FFFFFF'),
                            Icons.share,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Répondez au questionnaire".tr,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorExtension.toColor('#FF914D'),
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
                            for (int index = 0; index < surveyProvider.survey['surveyforms'].length; index++) SurveyRetrieve(item: new SurveyForm(surveyProvider.survey['surveyforms'][index]['id'], surveyProvider.survey['surveyforms'][index]['question'], surveyProvider.survey['surveyforms'][index]['type'], surveyProvider.survey['surveyforms'][index]['proposal'], surveyProvider.survey['surveyforms'][index]['answer'], surveyProvider.survey['surveyforms'][index]['survey'], surveyProvider.survey['surveyforms'][index]['surveyresponses']), index: index, listResponse: listResponse, functionCallback: (i, controller) {
                              if (surveyProvider.survey['surveyforms'][index]['type'] == 2) {
                                if (controller.text != null && !controller.text.trim().isEmpty) {
                                  setState(() {
                                    listResponse['${i}'] = {
                                      'surveyform': surveyProvider.survey['surveyforms'][i]['id'],
                                      'controller': controller,
                                      'answer': controller.text,
                                    };
                                  });
                                } else {
                                  if (listResponse.containsKey('${i}')) {
                                    setState(() {
                                      listResponse.remove('${i}');
                                    });
                                  }
                                }
                              } else if (surveyProvider.survey['surveyforms'][index]['type'] == 3) {
                                if (controller.text != null && !controller.text.trim().isEmpty) {
                                  setState(() {
                                    listResponse['${i}'] = {
                                      'surveyform': surveyProvider.survey['surveyforms'][i]['id'],
                                      'controller': controller,
                                      'answer': controller.text,
                                    };
                                  });
                                } else {
                                  if (listResponse.containsKey('${i}')) {
                                    setState(() {
                                      listResponse.remove('${i}');
                                    });
                                  }
                                }
                              } else {
                                if (controller.text != null && !controller.text.trim().isEmpty) {
                                  listResponse['${i}'] = {
                                    'surveyform': surveyProvider.survey['surveyforms'][i]['id'],
                                    'controller': controller,
                                    'answer': controller.text,
                                  };
                                } else {
                                  if (listResponse.containsKey('${i}')) {
                                    listResponse.remove('${i}');
                                  }
                                }
                              }
                            }),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate() && listResponse.length == surveyProvider.survey['surveyforms'].length) {
                                        try {
                                          http.Response responseSurveyUser = await createSurveyUser(token, tokenRefresh, first_name: surveyController.survey['first_name'], last_name: surveyController.survey['last_name'], phone: surveyController.survey['phone'], email: surveyController.survey['email'], zipcode: surveyController.survey['zipcode'], survey: surveyProvider.survey['id']);
                                          var bodySurveyUser = json.decode(utf8.decode(responseSurveyUser.bodyBytes));
                                          listResponse.forEach((i, v) async {
                                            listResponse[i]['surveyuser'] = bodySurveyUser['id'];
                                            http.Response responseSurveyUserResponse = await createSurveyResponse(token, tokenRefresh, surveyuser: listResponse[i]['surveyuser'], surveyform: listResponse[i]['surveyform'], answer: listResponse[i]['answer'].replaceAll(';', '\n').trim());
                                            var bodySurveyResponse = json.decode(utf8.decode(responseSurveyUserResponse.bodyBytes));
                                            listResponse[i]['controller'].clear();
                                          });
                                          setState(() {
                                            listResponse = {};
                                          });
                                          switch (responseSurveyUser.statusCode) {
                                            case 201:
                                              Flushbar(
                                                icon: Icon(
                                                  Icons.info_outline,
                                                  size: 28.0,
                                                  color: Colors.blue,
                                                ),
                                                duration: Duration(seconds: 3),
                                                leftBarIndicatorColor: Colors.blue,
                                                flushbarPosition: FlushbarPosition.TOP,
                                                title: 'Sondage'.tr,
                                                message: "La soumission du sondage a été effectué",
                                              )..show(context);
                                              await Future.delayed(const Duration(seconds: 3));
                                              Get.toNamed(Routes.menu);
                                              break;
                                            case 404:
                                              Flushbar(
                                                icon: Icon(
                                                  Icons.info_outline,
                                                  size: 28.0,
                                                  color: Colors.blue,
                                                ),
                                                duration: Duration(seconds: 3),
                                                leftBarIndicatorColor: Colors.blue,
                                                flushbarPosition: FlushbarPosition.TOP,
                                                title: 'Sondage'.tr,
                                                message: "Une réponse à déjà été donnée pour ce sondage",
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
                                                title: 'Sondage'.tr,
                                                message: "Une erreur a été rencontrée lors de la soumission du sondage",
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
                                            title: 'Sondage'.tr,
                                            message:  e.toString(),
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
                                          title: 'Sondage'.tr,
                                          message: 'Veuillez remplir ou sélectionner les champs'.tr,
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
                                      "Soumettre".tr,
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
