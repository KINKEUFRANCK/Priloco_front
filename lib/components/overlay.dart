import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader {
  static final Loader appLoader = Loader();
  ValueNotifier<bool> loaderShowingNotifier = ValueNotifier(true);

  void showLoader() {
    loaderShowingNotifier.value = true;
  }

  void hideLoader() {
    loaderShowingNotifier.value = false;
  }
}

class OverlayView extends StatelessWidget {
  final Widget item_1;
  final Widget? item_2;
  OverlayView({Key? key, required this.item_1, this.item_2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Loader.appLoader.loaderShowingNotifier,
      builder: (context, value, child) {
        if (value) {
          return Column(
            children: <Widget>[
              SpinKitFadingCircle(
                color: Colors.grey,
                size: 50.0,
              ),
              if (this.item_2 != null) ...[
                this.item_2!
              ],
            ],
          );
        } else {
          return this.item_1;
        }
      },
    );
  }
}
