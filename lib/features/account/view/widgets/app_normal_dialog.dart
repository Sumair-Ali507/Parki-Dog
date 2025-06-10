import 'package:flutter/material.dart';

Future<dynamic> showAppDialog(
  BuildContext context, {
  Widget? title,
  Widget? content,
  List<Widget>? actions,
  bool isDismissible = true,
  Color? bgColor,
  Color? surfaceTintColor,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: bgColor,
      surfaceTintColor: surfaceTintColor,
      title: title,
      content: content,
      actions: actions,
      scrollable: true,
    ),
    barrierDismissible: isDismissible,
  );
}
