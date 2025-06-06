import 'package:flutter/material.dart';

class BottomsheetService {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  static void showBottomSheet(Widget child) {
    _scaffoldKey.currentState!.showBottomSheet(
      (context) => child,
    );
  }
}
