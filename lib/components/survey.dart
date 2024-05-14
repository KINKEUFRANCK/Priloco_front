import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/controllers/login.dart';

LineSplitter ls = new LineSplitter();

class SurveyItem { 
   const SurveyItem(this.id, this.title, this.description, this.is_active, this.user, this.surveyforms, this.surveyusers); 
   final int id; 
   final String title; 
   final String description; 
   final bool is_active; 
   final int user; 
   final List<dynamic> surveyforms; 
   final List<dynamic> surveyusers; 
}

class SurveyForm { 
   const SurveyForm(this.id, this.question, this.type, this.proposal, this.answer, this.survey, this.surveyresponses); 
   final int id; 
   final String question; 
   final int type; 
   final String proposal; 
   final String answer; 
   final int survey; 
   final List<dynamic> surveyresponses; 
}

class SurveyList extends StatelessWidget {
  final SurveyItem item;
  SurveyList({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final loginControl = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ColorExtension.toColor('#EEEEEE'),
            width: 0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container( 
          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        this.item.title,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ColorExtension.toColor('#000000'),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (loginControl.authenticated && loginControl.role < 2) ...[
                        GestureDetector(
                          onTap: () async {
                            await downloadFile(token, tokenRefresh, id: this.item.id, title: this.item.title);
                            Flushbar(
                              icon: Icon(
                                Icons.info_outline,
                                size: 28.0,
                                color: Colors.blue,
                              ),
                              duration: Duration(seconds: 3),
                              leftBarIndicatorColor: Colors.blue,
                              flushbarPosition: FlushbarPosition.TOP,
                              title: 'Sondages',
                              message: "Téléchargement effectué dans votre téléphone",
                            )..show(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                size: 30.0,
                                color: ColorExtension.toColor('#FF914D'),
                                Icons.download_for_offline,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              size: 30.0,
                              color: ColorExtension.toColor('#9E9E9E'),
                              Icons.article,
                            ),
                          ),
                        ),
                      ],
                    ], 
                  ),
                ], 
              ),
            ],
          ),
        ),
      ),
    ); 
  } 
}

class SurveyRetrieve extends StatelessWidget {
  final SurveyForm item;
  final int index;
  final Map<String, dynamic> listResponse;
  final Function(int, TextEditingController) functionCallback;
  SurveyRetrieve({Key? key, required this.item, required this.index, required this.listResponse, required this.functionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<String> listProposal = ls.convert(this.item.proposal);
    TextEditingController controller = TextEditingController(text: listResponse.containsKey('${this.index}') ? listResponse['${this.index}']['answer'] : '');

    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.03, width: size.width * 0.08),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(this.item.question,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorExtension.toColor('#F69723'),
              ),
            ),
          ),
          if (this.item.type == 2) ...[
            SizedBox(height: size.height * 0.005, width: size.width * 0.08),
          ] else if (this.item.type == 3) ...[
            SizedBox(height: size.height * 0.005, width: size.width * 0.08),
          ] else ...[
            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
          ],
          if (this.item.type == 2) ...[
            for (int index = 0; index < listProposal.length; index++) RadioListTile<String>(
              title: Text(
                listProposal[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorExtension.toColor('#000000'),
                ),
              ),
              value: listProposal[index], 
              groupValue: controller.text, 
              onChanged: (String? value) {
                controller.text = value!;
                this.functionCallback(this.index, controller);
              },
            ),
          ] else if (this.item.type == 3) ...[
            for (int index = 0; index < listProposal.length; index++) CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                listProposal[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorExtension.toColor('#000000'),
                ),
              ),
              value: listResponse.containsKey('${this.index}') ? (listResponse['${this.index}']['answer'].contains(listProposal[index]) ?? false) : false, 
              onChanged: (bool? value) {
                controller.text = value! ? (controller.text + listProposal[index] + ';').trim() : controller.text.replaceAll(listProposal[index] + ';', '').trim();
                this.functionCallback(this.index, controller);
              },
            ),
          ] else ...[
            TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              onChanged: (value) async {
                this.functionCallback(this.index, controller);
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez remplir ce champ'.tr;
                }
                return null;
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                hintText: "Réponse ${this.index+1} *",
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 2),
                  child: Icon(FontAwesomeIcons.solidQuestionCircle,),
                ),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
          if (this.item.type == 2) ...[
            SizedBox(height: size.height * 0.005, width: size.width * 0.08),
          ] else if (this.item.type == 3) ...[
            SizedBox(height: size.height * 0.005, width: size.width * 0.08),
          ] else ...[
            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
          ],
          Container(
            width: size.width * 0.95,
            child: Divider(
              thickness: 0.5,
              color: ColorExtension.toColor('#DDDDDD'),
            ),
          ),
        ],
      ),
    ); 
  } 
}
