import 'package:get/get.dart';

import 'package:bonsplans/middlewares/login.dart';

import 'package:bonsplans/screens/auth/login.dart';
import 'package:bonsplans/screens/auth/logout.dart';
import 'package:bonsplans/screens/auth/register.dart';
import 'package:bonsplans/screens/auth/password_reset_1.dart';
import 'package:bonsplans/screens/auth/password_reset_2.dart';
import 'package:bonsplans/screens/auth/password_reset_3.dart';
import 'package:bonsplans/screens/auth/registration_verify_1.dart';
import 'package:bonsplans/screens/auth/registration_verify_2.dart';
import 'package:bonsplans/screens/auth/registration_verify_3.dart';
import 'package:bonsplans/screens/auth/password_change.dart';
import 'package:bonsplans/screens/page/welcome.dart';
import 'package:bonsplans/screens/page/intro.dart';
import 'package:bonsplans/screens/page/menu.dart';
import 'package:bonsplans/screens/page/location.dart';
import 'package:bonsplans/screens/survey/create_step_1.dart';
import 'package:bonsplans/screens/survey/create_step_2.dart';
import 'package:bonsplans/screens/survey/create_step_3.dart';
import 'package:bonsplans/screens/survey/list.dart';
import 'package:bonsplans/screens/post/retrieve.dart';
import 'package:bonsplans/screens/post/list.dart';
import 'package:bonsplans/screens/post/create_step_1.dart';
import 'package:bonsplans/screens/post/create_step_2.dart';
import 'package:bonsplans/screens/post/create_step_3.dart';
import 'package:bonsplans/screens/post/create_step_4.dart';
import 'package:bonsplans/screens/post/create_step_5.dart';
import 'package:bonsplans/screens/post/post_update_step_1.dart';
import 'package:bonsplans/screens/post/post_update_step_2.dart';
import 'package:bonsplans/screens/page/language.dart';
import 'package:bonsplans/screens/review/create.dart';
import 'package:bonsplans/screens/page/contactservice.dart';
import 'package:bonsplans/screens/page/about.dart';
import 'package:bonsplans/screens/favoritecategory/list.dart';

class Routes {
  static String welcome = '/welcome';
  static String intro = '/intro';
  static String menu = '/menu';
  static String home = '/home';
  static String account = '/account';
  static String favorite = '/favorite';
  static String notification_list = '/notification_list';
  static String survey_list = '/survey_list';
  static String survey_create_step_1 = '/survey_create_step_1';
  static String survey_create_step_2 = '/survey_create_step_2';
  static String survey_create_step_3 = '/survey_create_step_3';
  static String category_list = '/category_list';
  static String login= '/login';
  static String logout = '/logout';
  static String register = '/register';
  static String password_reset_1 = '/password_reset_1';
  static String password_reset_2 = '/password_reset_2';
  static String password_reset_3 = '/password_reset_3';
  static String registration_verify_1 = '/registration_verify_1';
  static String registration_verify_2 = '/registration_verify_2';
  static String registration_verify_3 = '/registration_verify_3';
  static String password_change = '/password_change';
  static String settings = '/settings';
  static String profile = '/profile';
  static String post_retrieve = '/post_retrieve';
  static String post_list = '/post_list';
  static String post_create_step_1 = '/post_create_step_1';
  static String post_create_step_2 = '/post_create_step_2';
  static String post_create_step_3 = '/post_create_step_3';
  static String post_create_step_4 = '/post_create_step_4';
  static String post_create_step_5 = '/post_create_step_5';
  static String post_update_step_1 = '/post_update_step_1';
  static String post_update_step_2 = '/post_update_step_2';
  static String location = '/location';
  static String language = '/language';
  static String review_create = '/review_create';
  static String favoritecategory = '/favoritecategory';
  static String contactservice = '/contactservice';
  static String about = '/about';
}

final pages = [
  GetPage(
    name: Routes.welcome,
    page: () => const WelcomeScreen(title: 'Bienvenue | Priloco'),
  ),
  GetPage(
    name: Routes.intro,
    page: () => const IntroScreen(title: 'Intro | Priloco'),
  ),
  GetPage(
    name: Routes.menu,
    page: () => const MenuScreen(title: 'Menu | Priloco'),
  ),
  GetPage(
    name: Routes.login,
    page: () => const LoginScreen(title: 'Connexion | Priloco'),
  ),
  GetPage(
    name: Routes.logout,
    page: () => const LogoutScreen(title: 'Déconnexion | Priloco'),
  ),
  GetPage(
    name: Routes.register,
    page: () => const RegisterScreen(title: 'Inscription | Priloco'),
  ),
  GetPage(
    name: Routes.password_reset_1,
    page: () => const PasswordReset1Screen(title: 'Mot de passe oublié ? | Priloco'),
  ),
  GetPage(
    name: Routes.password_reset_2,
    page: () => const PasswordReset2Screen(title: 'Mot de passe oublié ? | Priloco'),
  ),
  GetPage(
    name: Routes.password_reset_3,
    page: () => const PasswordReset3Screen(title: 'Mot de passe oublié ? | Priloco'),
  ),
  GetPage(
    name: Routes.registration_verify_1,
    page: () => const RegistrationVerify1Screen(title: 'Confirmation de votre compte ? | Priloco'),
  ),
  GetPage(
    name: Routes.registration_verify_2,
    page: () => const RegistrationVerify2Screen(title: 'Confirmation de votre compte ? | Priloco'),
  ),
  GetPage(
    name: Routes.registration_verify_3,
    page: () => const RegistrationVerify3Screen(title: 'Confirmation de votre compte ? | Priloco'),
  ),
  GetPage(
    name: Routes.password_change,
    page: () => const PasswordChangeScreen(title: 'Modifier le mot de passe | Priloco'),
    middlewares: [
      LoginMiddleware(priority: 1),
    ],
  ),
  GetPage(
    name: Routes.post_retrieve,
    page: () => const PostRetrieveScreen(title: 'Offre | Priloco'),
  ),
  GetPage(
    name: Routes.post_list,
    page: () => const PostListScreen(title: 'Offres | Priloco'),
  ),
  GetPage(
    name: Routes.location,
    page: () => const LocationScreen(title: 'Ma localisation | Priloco'),
  ),
  GetPage(
    name: Routes.survey_create_step_1,
    page: () => const SurveyCreateStep1Screen(title: 'Sondage | Priloco'),
  ),
  GetPage(
    name: Routes.survey_create_step_2,
    page: () => const SurveyCreateStep2Screen(title: 'Sondage | Priloco'),
  ),
  GetPage(
    name: Routes.survey_create_step_3,
    page: () => const SurveyCreateStep3Screen(title: 'Sondage | Priloco'),
  ),
  GetPage(
    name: Routes.survey_list,
    page: () => const SurveyListScreen(title: 'Sondages | Priloco'),
  ),
  GetPage(
    name: Routes.language,
    page: () => const LanguageScreen(title: 'Langue | Priloco'),
  ),
  GetPage(
    name: Routes.post_create_step_1,
    page: () => const PostCreateStep1Screen(title: 'Publier une offre | Priloco'),
    middlewares: [
      LoginMiddleware(priority: 1),
    ],
  ),
  GetPage(
    name: Routes.post_create_step_2,
    page: () => const PostCreateStep2Screen(title: 'Publier une offre | Priloco'),
    middlewares: [
      LoginMiddleware(priority: 1),
    ],
  ),
  GetPage(
    name: Routes.post_create_step_3,
    page: () => const PostCreateStep3Screen(title: 'Publier une offre | Priloco'),
    middlewares: [
      LoginMiddleware(priority: 1),
    ],
  ),
  GetPage(
    name: Routes.post_create_step_4,
    page: () => const PostCreateStep4Screen(title: 'Publier une offre | Priloco'),
    middlewares: [
      LoginMiddleware(priority: 1),
    ],
  ),
  GetPage(
    name: Routes.post_create_step_5,
    page: () => const PostCreateStep5Screen(title: 'Publier une offre | Priloco'),
    middlewares: [
      LoginMiddleware(priority: 1),
    ],
  ),
  GetPage(
    name: Routes.post_update_step_1,
    page: () => const PostUpdateStep1Screen(title: 'Modifier une offre | Priloco'),
    middlewares: [
      LoginMiddleware(priority: 1),
    ],
  ),
  GetPage(
    name: Routes.post_update_step_2,
    page: () => const PostUpdateStep2Screen(title: 'Modifier une offre | Priloco'),
    middlewares: [
      LoginMiddleware(priority: 1),
    ],
  ),
  GetPage(
    name: Routes.review_create,
    page: () => const ReviewCreateScreen(title: 'Avis | Priloco'),
    middlewares: [
      LoginMiddleware(priority: 1),
    ],
  ),
  GetPage(
    name: Routes.favoritecategory,
    page: () => const FavoriteCategoryListScreen(title: 'Préférences | Priloco'),
  ),
  GetPage(
    name: Routes.contactservice,
    page: () => const ContactServiceScreen(title: 'Service client | Priloco'),
  ),
  GetPage(
    name: Routes.about,
    page: () => const AboutScreen(title: 'A propos de Priloco | Priloco'),
  ),
];
