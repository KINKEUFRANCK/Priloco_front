import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> launcherUrl(String? url, {String type = 'url'}) async {
  if (type == 'tel') {
    url = 'tel:${url.toString()}';
  } else if (type == 'app') {
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/apps/details?id=${url.toString()}';
    } else if (Platform.isIOS) {
      url = 'https://apps.apple.com/app/id${url.toString()}';
    } else {
      url = url.toString();
    }

    url = 'https://api.whatsapp.com/send?text=${url}';
  } else {
    url = url.toString();
  }

  print('totototototo url: ${url}');

  Uri _uri = Uri.parse(url);

  if (await canLaunchUrl(_uri)) {
    await launchUrl(_uri, mode: LaunchMode.externalApplication);
  } else {
    print('totototototo url: Could not launch ${url}');
  }
}
