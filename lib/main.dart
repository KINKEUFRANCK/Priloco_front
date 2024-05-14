import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/providers/category.dart';
import 'package:bonsplans/providers/post.dart';
import 'package:bonsplans/providers/favorite.dart';
import 'package:bonsplans/providers/notification.dart';
import 'package:bonsplans/providers/survey.dart';
import 'package:bonsplans/providers/favoritecategory.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/locales/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:bonsplans/utils/notification.dart';
import 'package:bonsplans/configs/constants.dart';

/// Flutter code sample for [SingleChildScrollView].

void main() async {
  if (!Platform.isIOS) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    // NotificationService notificationService = NotificationService();
    // await notificationService.initializePlatformNotifications();
    MobileAds.instance.initialize();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget { 
   // This widget is the root of your application. 
  @override 
  Widget build(BuildContext context) { 
    return MultiProvider(
      providers: 
      [
        ChangeNotifierProvider(create:  (context) => AuthProvider(),),
        ChangeNotifierProvider(create:  (context) => CategoryProvider(),),
        ChangeNotifierProvider(create:  (context) => PostProvider(),),
        ChangeNotifierProvider(create:  (context) => FavoriteProvider(),),
        ChangeNotifierProvider(create:  (context) => NotificationProvider(),),
        ChangeNotifierProvider(create:  (context) => SurveyProvider(),),
        ChangeNotifierProvider(create:  (context) => FavoriteCategoryProvider(),),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Priloco',
        theme: ThemeData(
          primaryColor: ColorExtension.toColor('#000000'),
          fontFamily: 'Poppins',
        ),
        initialRoute: Routes.welcome,
        getPages: pages,
        translations: Messages(),
        locale: Locale(Constants.locales[0]),
        fallbackLocale: Locale(Constants.locales[0]),
      ),
    );
  }
}
