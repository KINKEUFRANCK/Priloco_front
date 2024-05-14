import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/providers/survey.dart';
import 'package:bonsplans/configs/constants.dart';

import 'package:bonsplans/components/overlay.dart';

class SurveyCreateStep1Screen extends StatefulWidget {
  static String id = Routes.survey_create_step_3;
  final String title;

  const SurveyCreateStep1Screen({Key? key, required this.title}) : super(key: key);

  @override
  State<SurveyCreateStep1Screen> createState() => _SurveyCreateStep1ScreenState();
}

class _SurveyCreateStep1ScreenState extends State<SurveyCreateStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  bool _isFilter = false;
  bool _isFavorite = false;
  Map<String, dynamic> listResponse = {};

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final surveyProvider = Provider.of<SurveyProvider>(context);
    final survey = Get.arguments?['survey'];
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          if (!_isFavorite) {
            Loader.appLoader.showLoader();
          }

          http.Response responseSurvey = await retrieveSurvey(token, tokenRefresh, id: survey);
          var bodySurvey = json.decode(utf8.decode(responseSurvey.bodyBytes));

          surveyProvider.survey = bodySurvey;

          if (!_isFavorite) {
            Loader.appLoader.hideLoader();
          }
        } on Exception catch (e, s) {
          print('totototototo exception: ${e.toString()}');
        }
        setState(() {
          _isFilter = true;
          _isFavorite = false;
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
                SizedBox(height: 10, width: size.width),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Form(
                        key: _formKey,
                        child: OverlayView(
                          item_1: Column(
                            children: <Widget>[
                              Container(
                                width: size.width,
                                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                margin: EdgeInsets.only(top: 10),
                                child: Text(surveyProvider.survey['description'],
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 14,
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
                                        Get.toNamed(Routes.survey_create_step_2);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 1.0,
                                        backgroundColor: ColorExtension.toColor('#FF914D'),
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                        padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18)
                                      ),
                                      child: Text(
                                        "Démarrer".tr,
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
