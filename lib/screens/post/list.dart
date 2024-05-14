import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/providers/post.dart';
import 'package:bonsplans/providers/favorite.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/controllers/login.dart';
import 'package:bonsplans/controllers/location.dart';

import 'package:bonsplans/components/post.dart';
import 'package:bonsplans/components/overlay.dart';

class PostListScreen extends StatefulWidget {
  static String id = Routes.post_list;
  final String title;

  const PostListScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  ScrollController scrollController = ScrollController();
  bool _isFilter = false;
  bool _isFavorite = false;
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
    final locationControl = Get.put(LocationController());
    final loginControl = Get.put(LoginController());
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final category = Get.arguments?['category'];
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          if (!_isFavorite) {
            Loader.appLoader.showLoader();
          }

          http.Response responsePosts = await listPosts(token, tokenRefresh, distance: locationControl.distance, unit: locationControl.unit, latitude: locationControl.latitude, longitude: locationControl.longitude, category: category, authenticated: loginControl.authenticated, limit: limit, offset: offset);
          var bodyPosts = json.decode(utf8.decode(responsePosts.bodyBytes));

          if (loginControl.authenticated) {
            http.Response responseFavorites = await listFavorites(token, tokenRefresh);
            var bodyFavorites = json.decode(utf8.decode(responseFavorites.bodyBytes));

            count = bodyPosts['count'];
            if (offset == 0) {
              postProvider.posts = [];
            }
            postProvider.posts += bodyPosts['results'];
            if (postProvider.posts.length > 0) {
              postProvider.post = postProvider.posts[0];
            }
            favoriteProvider.favorites = bodyFavorites;
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
                          child: Text("Offres".tr,
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
                            color: ColorExtension.toColor('#FF914D'),
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
                  child: Container(
                    width: size.width,
                    margin: EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: OverlayView(
                          item_1: Column(
                            children: <Widget>[
                              if (postProvider.posts.length > 0) ...[
                                for (int index = 0; index < postProvider.posts.length; index++) PostList(item: new Post(postProvider.posts[index]['id'], postProvider.posts[index]['title'], postProvider.posts[index]['content'], postProvider.posts[index]['phone'], postProvider.posts[index]['service'], postProvider.posts[index]['condition'], postProvider.posts[index]['location'], num.tryParse(postProvider.posts[index]['price'].toString())?.toDouble(), postProvider.posts[index]['currency'], postProvider.posts[index]['promotion'], postProvider.posts[index]['photos'], postProvider.posts[index]['view'], postProvider.posts[index]['reviews']), functionCallback: (favorite) {
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
