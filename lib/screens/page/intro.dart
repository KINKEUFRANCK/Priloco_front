import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';

class IntroScreen extends StatefulWidget {
  static String id = Routes.intro;
  final String title;

  const IntroScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final storage = new FlutterSecureStorage();
  final _introKey = GlobalKey<IntroductionScreenState>();

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
            child: IntroductionScreen(
              key: _introKey,
              pages: [
                PageViewModel(
                  titleWidget: Text(
                    'Bienvenue sur Priloco',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorExtension.toColor('#000000'),
                    ),
                  ),
                  bodyWidget: Text(
                    "L'application de mise en relation révolutionnaire qui connecte les annonceurs locaux et les clients à la recherche de produits et services.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorExtension.toColor('#000000'),
                    ),
                  ),
                  image: Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                  ),
                  decoration: PageDecoration(
                    pageColor: ColorExtension.toColor('#FFFFFF'),
                  ),
                ),
              ],
              showBackButton: true,
              showNextButton: true,
              showDoneButton: true,
              skip: Text(
                'Ignorer'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorExtension.toColor('#000000'),
                ),
              ),
              back: Text(
                'Retour'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorExtension.toColor('#000000'),
                ),
              ),
              next: Text(
                'Suivant'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorExtension.toColor('#000000'),
                ),
              ),
              done: Text(
                'Terminé'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorExtension.toColor('#000000'),
                ),
              ),
              onDone: () async {
                await storage.write(key: 'intro', value: 'intro');
                Get.offAndToNamed(Routes.menu);
              },
            ),
          ),
        ),
      ),
    );
  }
}
