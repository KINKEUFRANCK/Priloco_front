import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:bonsplans/configs/constants.dart';

class Ad {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return Constants.bannerAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return Constants.bannerAdUnitIdIOS;
    } else {
      return '';
    }
  }
}

Future<BannerAd?> loadBannerAd(Function() functionCallback) async {
  return BannerAd(
      adUnitId: Ad.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          print('totototototo ad: ${ad}');
          functionCallback();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          print('totototototo err: ${err}');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
}
