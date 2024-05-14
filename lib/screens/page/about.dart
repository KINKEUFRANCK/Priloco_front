import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';

class AboutScreen extends StatefulWidget {
  static String id = Routes.about;
  final String title;

  const AboutScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
                          child: Text("A propos de Priloco".tr,
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Bienvenue sur Priloco, l'application de mise en relation révolutionnaire qui connecte les annonceurs locaux et les clients à la recherche de produits et services. Priloco vous permet de  découvrir et acquérir des offres à proximité, tout en favorisant un lien direct entre les annonceurs et les consommateurs.".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Notre Vision".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Chez Priloco, notre vision est de dynamiser les économies locales en connectant de manière transparente les annonceurs et les clients au sein de leur communauté. Nous offrons aux consommateurs un accès privilégié à des offres à proximité.".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Caractéristiques Principales".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "- Géolocalisation Précise : Notre technologie de pointe permet aux clients de trouver rapidement des offres à proximité, adaptées à leurs besoins et préférences.".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "- Interactions Faciles : Les utilisateurs peuvent contacter directement les annonceurs pour acheter des produits ou services, créant ainsi une expérience d'achat conviviale et personnalisée.".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "- Mise en avant Efficace : Les annonceurs peuvent mettre en avant leurs offres spéciales.".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "- Aucun frais de commission sur les ventes.".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Inspirations Derrière Priloco".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "L'inspiration derrière Priloco réside dans notre désir de renforcer les liens au sein des communautés locales et de soutenir les entreprises régionales. Nous croyons fermement que la technologie peut servir de catalyseur pour favoriser des relations commerciales authentiques et durables.".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Notre Engagement envers Vous".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Chez Priloco, nous nous engageons à offrir une plateforme fiable, sécurisée et conviviale, créant ainsi un environnement propice à l'épanouissement des entreprises locales et à la satisfaction des besoins des consommateurs. Notre équipe est déterminée à soutenir votre succès et à vous offrir une expérience inégalée.".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Découvrez votre allié d’aujourd’hui !!!".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02, width: size.width * 0.08),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pour des questions, suggestions et autres besoins, veuillez contacter le service client à l’adresse priloco@tenteeglobal.com".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
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
