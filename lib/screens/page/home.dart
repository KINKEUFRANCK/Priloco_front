import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/utils/google_ad.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/providers/post.dart';
import 'package:bonsplans/providers/favorite.dart';
import 'package:bonsplans/providers/favoritecategory.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/controllers/login.dart';
import 'package:bonsplans/controllers/location.dart';

import 'package:bonsplans/components/post.dart';
import 'package:bonsplans/components/overlay.dart';

class HomeScreen extends StatefulWidget {
  static String id = Routes.home;
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool _isFilter = false;
  bool _isLoaded = false;
  bool _isFavorite = false;
  BannerAd? _bannerAd;
  int count = 0;
  int limit = Constants.limit;
  int offset = 0;

  void _onScrollEvent() async {
    final extentAfter = scrollController.position.extentAfter;
    if (extentAfter == 0.0) {
      if ((offset + limit) < count) {
        offset += limit;
        setState(() {
          _isFilter = false;
        });
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(_onScrollEvent);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final postProvider = Provider.of<PostProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favoriteCategoryProvider = Provider.of<FavoriteCategoryProvider>(context);
    final loginControl = Get.put(LoginController());
    final locationControl = Get.put(LocationController());
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;
    bool _isFavoriteCategory = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /* if (!_isLoaded) {
        _bannerAd = await loadBannerAd(() {
          _isLoaded = true;
        });
      } */

      if (!_isFilter) {
        try {
          if (!_isFavorite) {
            Loader.appLoader.showLoader();
          }

          http.Response responsePosts = await listPosts(token, tokenRefresh, distance: locationControl.distance, unit: locationControl.unit, latitude: locationControl.latitude, longitude: locationControl.longitude, search: searchController.text, location: locationController.text, authenticated: loginControl.authenticated, limit: limit, offset: offset);
          var bodyPosts = json.decode(utf8.decode(responsePosts.bodyBytes));

          if (loginControl.authenticated) {
            http.Response responseFavorites = await listFavorites(token, tokenRefresh);
            var bodyFavorites = json.decode(utf8.decode(responseFavorites.bodyBytes));

            http.Response responseFavoriteCategories = await listFavoriteCategories(token, tokenRefresh);
            var bodyFavoriteCategories = json.decode(utf8.decode(responseFavoriteCategories.bodyBytes));

            count = bodyPosts['count'];
            if (offset == 0) {
              postProvider.posts = [];
            }
            postProvider.posts += bodyPosts['results'];
            if (postProvider.posts.length > 0) {
              postProvider.post = postProvider.posts[0];
            }
            favoriteProvider.favorites = bodyFavorites;
            favoriteCategoryProvider.favoritecategories = bodyFavoriteCategories;
          } else {
            count = bodyPosts['count'];
            if (offset == 0) {
              postProvider.posts = [];
            }
            postProvider.posts += bodyPosts['results'];
            if (postProvider.posts.length > 0) {
              postProvider.post = postProvider.posts[0];
            }
          }

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
      floatingActionButton: (loginControl.authenticated && loginControl.role < 3) ? FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.post_create_step_1);
        },
        backgroundColor: ColorExtension.toColor('#FF914D'),
        child: const Icon(Icons.add),
      ) : null,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: topHeight + 10),
            child: Column(
              children: <Widget>[
                Container(
                  child: Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: size.width * 0.82,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              width: 2,
                              color: ColorExtension.toColor('#DDDDDD'),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: searchController,
                                    onChanged: (value) async {
                                      if (value.length >= 3 || value.length == 0) {
                                        postProvider.posts = [];
                                      }
                                      setState(() {
                                        _isFilter = false;
                                      });
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
                                      hintText: "Rechercher...".tr,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 10),
                                        child: Icon(FontAwesomeIcons.search,),
                                      ),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                                height: 25.0,
                                color: ColorExtension.toColor('#DDDDDD'),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: locationController,
                                    onChanged: (value) async {
                                      if (value.length >= 3 || value.length == 0) {
                                        postProvider.posts = [];
                                      }
                                      setState(() {
                                        _isFilter = false;
                                      });
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
                                      hintText: "Lieux...".tr,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 10),
                                        child: Icon(FontAwesomeIcons.mapMarkerAlt,),
                                      ),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              iconSize: 22.0,
                              color: ColorExtension.toColor('#FF914D'),
                              onPressed: () {},
                              icon: Icon(
                                FontAwesomeIcons.shoppingCart,
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: size.width,
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                            margin: EdgeInsets.only(top: 15.0),
                            decoration: BoxDecoration(
                              color: ColorExtension.toColor('#ECEFF4'),
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              softWrap: true,
                              text: TextSpan(children: <TextSpan> [
                                TextSpan(
                                  text: "Jusqu'à ".tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorExtension.toColor('#000000'),
                                  ),
                                ),
                                TextSpan(
                                  text: "-25% ".tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: ColorExtension.toColor('#506092'),
                                  ),
                                ),
                                TextSpan(
                                  text: "sur les offres locales !".tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorExtension.toColor('#000000'),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Column(
                                children: <Widget>[
                                  if (searchController.text.length == 0 && locationController.text.length == 0) ...[
                                    Center(
                                      child: Container(
                                        width: size.width,
                                        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                        margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                          color: ColorExtension.toColor('#F9E9EA'),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      /* if (_bannerAd != null) ...[
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 10, right: 10),
                                                          child: Align(
                                                            alignment: Alignment.topCenter,
                                                            child: SafeArea(
                                                              child: SizedBox(
                                                                width: _bannerAd!.size.width.toDouble(),
                                                                height: _bannerAd!.size.height.toDouble(),
                                                                child: AdWidget(ad: _bannerAd!),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ], */
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: RichText(
                                                          textAlign: TextAlign.center,
                                                          softWrap: true,
                                                          text: TextSpan(children: <TextSpan> [
                                                            TextSpan(
                                                              text: "Les 20 offres les plus récentes\n".tr,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                                decoration: TextDecoration.underline,
                                                                color: ColorExtension.toColor('#000000'),
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: "Economisez jusqu'à 70%\n".tr,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                                color: ColorExtension.toColor('#d82e2f'),
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: "en plus !".tr,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                                color: ColorExtension.toColor('#000000'),
                                                              ),
                                                            ),
                                                          ]),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                            Get.toNamed(Routes.survey_list);
                                                          },
                                                        child: Text(
                                                          'Participez à nos sondages'.tr,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            decoration: TextDecoration.underline,
                                                            color: ColorExtension.toColor('#000000'),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Image.asset(
                                                  'assets/images/ad.png',
                                                  width: 100,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    SizedBox(height: 10, width: size.width),
                                  ],
                                  OverlayView(
                                    item_1: Column(
                                      children: <Widget>[
                                        if (postProvider.posts.length > 0) ...[
                                          for (int index = 0; index < postProvider.posts.length; index++) if (favoriteCategoryProvider.favoritecategories.length == 0 || favoriteCategoryProvider.favoritecategories.map((favorite) => favorite['category']).toList().contains(postProvider.posts[index]['categories'][0]) == true) if (_isFavoriteCategory = true) PostList(item: new Post(postProvider.posts[index]['id'], postProvider.posts[index]['title'], postProvider.posts[index]['content'], postProvider.posts[index]['phone'], postProvider.posts[index]['service'], postProvider.posts[index]['condition'], postProvider.posts[index]['location'], num.tryParse(postProvider.posts[index]['price'].toString())?.toDouble(), postProvider.posts[index]['currency'], postProvider.posts[index]['promotion'], postProvider.posts[index]['photos'], postProvider.posts[index]['view'], postProvider.posts[index]['reviews']), functionCallback: (favorite) {
                                            if (favorite != null) {
                                              if (favorite['action'] == 1) {
                                                favoriteProvider.favorites.add(favorite);
                                              } else {
                                                favoriteProvider.favorites.removeWhere((item) => item['post'] == favorite['post']);
                                              }
                                            }
                                            setState(() {
                                              _isFilter = false;
                                              _isFavorite = true;
                                            });
                                          }),
                                          if (!_isFavoriteCategory) ...[
                                            Container(
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
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 10),
                                                              child: Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  "Pas d'offres disponibles...".tr,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: ColorExtension.toColor('#95989A'),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                                                            child: Align(
                                                            alignment: Alignment.centerRight,
                                                              child: Icon(
                                                                size: 30.0,
                                                                color: ColorExtension.toColor('#95989A'),
                                                                Icons.error,
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
                                          ],
                                        ] else ...[
                                          Container(
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
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 10),
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                "Pas d'offres disponibles...".tr,
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: ColorExtension.toColor('#95989A'),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                                                          child: Align(
                                                          alignment: Alignment.centerRight,
                                                            child: Icon(
                                                              size: 30.0,
                                                              color: ColorExtension.toColor('#95989A'),
                                                              Icons.error,
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
                                        ],
                                      ],
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 2.0,
                    width: size.width * 0.95,
                    child: CustomPaint(painter: DashedLinePainter(),)
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

/* class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 10, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = ColorExtension.toColor('#DDDDDD')
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} */

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorExtension.toColor('#DDDDDD')
      ..strokeWidth = 1;

    Offset startX = Offset(0, size.height / 2);
    Offset endX = Offset(size.width, size.height / 2);

    canvas.drawLine(startX, endX, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
