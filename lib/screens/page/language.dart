import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/utils/locales.dart';

class LanguageScreen extends StatefulWidget {
  static String id = Routes.language;
  final String title;

  const LanguageScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  bool _isFilter = false;
  bool _isSubmit = false;
  var _currentLanguage = null;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? storageLocale = await storage.read(key: 'locale');

      if (!_isFilter) {
        try {
          if (storageLocale != null) {
            await updateLocale(storageLocale);
            _currentLanguage = storageLocale;
          } else {
            await storage.write(key: 'locale', value: Constants.locales[0]);
            await updateLocale(Constants.locales[0]);
            _currentLanguage = Constants.locales[0];
          }
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
                          child: Text("Langue".tr,
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
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 2),
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Sélectionnez votre langue".tr,
                    textAlign: TextAlign.left,
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
                            SizedBox(height: size.height * 0.04, width: size.width * 0.08),
                            Container(
                              width: size.width,
                              height: 50,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: ColorExtension.toColor('#FFFFFF'),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  width: 1,
                                  color: ColorExtension.toColor('#9E9E9E'),
                                ),
                              ),
                              child: DropdownButton<String>(
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorExtension.toColor('#000000'),
                                ),
                                icon: Icon(
                                  FontAwesomeIcons.chevronDown, 
                                  size: 16,
                                ),
                                underline: Container(
                                  height: 0,
                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return Constants.locales.map((String value) {
                                    return Container(
                                      width: size.width*0.62,
                                      height: 50,
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          Constants.languages[value]!,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: Constants.locales.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      width: size.width*0.62,
                                      height: 50,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          Constants.languages[value]!,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ColorExtension.toColor('#000000'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  _currentLanguage = value;
                                  setState(() {
                                    _isFilter = true;
                                  });
                                },
                                value: _currentLanguage,
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (!_isSubmit) {
                                        setState(() {
                                          _isSubmit = true;
                                        });
                                        await storage.write(key: 'locale', value: _currentLanguage);
                                        await updateLocale(_currentLanguage);
                                        Get.toNamed(Routes.menu);
                                        setState(() {
                                          _isSubmit = false;
                                        });
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
                                      _isSubmit ? "Valider...".tr : "Valider".tr,
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
