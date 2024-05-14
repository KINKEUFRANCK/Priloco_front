import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bonsplans/utils/colors.dart';

Future<void> confirmDestroyUser(BuildContext context, Function(bool) functionCallback) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog( // <-- SEE HERE
        title: Text(
          'Confirmer la suppression ?'.tr,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        insetPadding: EdgeInsets.only(left: 30, right: 30),
        contentPadding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: <Widget>[
          SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SimpleDialogOption(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 22.0,
                          color: ColorExtension.toColor('#d82e2f'),
                          Icons.done,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Oui'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#d82e2f'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    functionCallback(true);
                    Navigator.of(context).pop();
                  },
                ),
                SimpleDialogOption(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 22.0,
                          color: ColorExtension.toColor('#000000'),
                          Icons.close,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Non'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#000000'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    functionCallback(false);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showPermissionLocation(BuildContext context, Function(bool) functionCallback) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return SimpleDialog( // <-- SEE HERE
        title: Text(
          'Demande de geocalisation'.tr,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        insetPadding: EdgeInsets.only(left: 30, right: 30),
        contentPadding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: <Widget>[
          SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Autoriser Priloco à accéder aux informations de localisation de votre appareil ?".tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorExtension.toColor('#000000'),
                  ),
                ),
                Text(
                  'Priloco utilisera votre localisation pour vous aider à découvrir les meilleures offres autour de vous.'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorExtension.toColor('#F69723'),
                  ),
                ),
                SimpleDialogOption(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 22.0,
                          color: ColorExtension.toColor('#000000'),
                          Icons.done,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Toujours activer la geocalisation'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#000000'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    functionCallback(true);
                    Navigator.of(context).pop();
                  },
                ),
                SimpleDialogOption(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 22.0,
                          color: ColorExtension.toColor('#d82e2f'),
                          Icons.close,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Ne pas activer la geocalisation'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#d82e2f'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    functionCallback(false);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showPermissionNotification(BuildContext context, Function(bool) functionCallback) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return SimpleDialog( // <-- SEE HERE
        title: Text(
          'Autoriser les notifications'.tr,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        insetPadding: EdgeInsets.only(left: 30, right: 30),
        contentPadding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: <Widget>[
          SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Recevez des alertes personnalisées instantanées et soyez au courant des meilleures offres en cours ?'.tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorExtension.toColor('#000000'),
                  ),
                ),
                Text(
                  'Nous vous enverrons les meilleurs deal du moment.'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorExtension.toColor('#F69723'),
                  ),
                ),
                SimpleDialogOption(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 22.0,
                          color: ColorExtension.toColor('#000000'),
                          Icons.done,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Toujours activer les notifications'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#000000'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    functionCallback(true);
                    Navigator.of(context).pop();
                  },
                ),
                SimpleDialogOption(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 22.0,
                          color: ColorExtension.toColor('#d82e2f'),
                          Icons.close,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "Ne pas activer les notifications".tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#d82e2f'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    functionCallback(false);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showPostOptions(BuildContext context, bool _isEnabled, Function(String) functionCallback) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog( // <-- SEE HERE
        title: Text(
          'Options'.tr,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        insetPadding: EdgeInsets.only(left: 30, right: 30),
        contentPadding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: <Widget>[
          SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (_isEnabled) ...[
                  SimpleDialogOption(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            size: 22.0,
                            color: ColorExtension.toColor('#000000'),
                            Icons.mode_edit,
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Modifier'.tr,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ColorExtension.toColor('#000000'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      functionCallback('update');
                      Navigator.of(context).pop();
                    },
                  ),
                  SimpleDialogOption(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            size: 22.0,
                            color: ColorExtension.toColor('#d82e2f'),
                            Icons.delete_outline,
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Supprimer'.tr,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ColorExtension.toColor('#d82e2f'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      functionCallback('destroy');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                SimpleDialogOption(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 22.0,
                          color: ColorExtension.toColor('#000000'),
                          Icons.share,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Partager'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#000000'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    functionCallback('share');
                    Navigator.of(context).pop();
                  },
                ),
                SimpleDialogOption(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 22.0,
                          color: ColorExtension.toColor('#000000'),
                          Icons.close,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Annuler'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#000000'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    functionCallback('');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<void> confirmDestroyPost(BuildContext context, Function(bool) functionCallback) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog( // <-- SEE HERE
        title: Text(
          'Confirmer la suppression ?'.tr,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        insetPadding: EdgeInsets.only(left: 30, right: 30),
        contentPadding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: <Widget>[
          SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SimpleDialogOption(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 22.0,
                          color: ColorExtension.toColor('#d82e2f'),
                          Icons.done,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Oui'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#d82e2f'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    functionCallback(true);
                    Navigator.of(context).pop();
                  },
                ),
                SimpleDialogOption(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 22.0,
                          color: ColorExtension.toColor('#000000'),
                          Icons.close,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Non'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#000000'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    functionCallback(false);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
