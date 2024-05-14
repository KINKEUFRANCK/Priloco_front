import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:bonsplans/configs/routes.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = Routes.welcome;
  final String title;

  const WelcomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  bool _isFilter = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          await Future.delayed(const Duration(seconds: 3));
          Get.offAndToNamed(Routes.menu);
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
                              Center(
                                child: Text(
                                  "Bienvenue".tr,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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
