import 'package:flutter/cupertino.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.text,
    required this.onPress,
    this.color = const Color(0xff064BB5),
    this.fontWeight,
    this.icon,
    this.edit,
  });

  final String text;
  final Color color;
  final Function() onPress;
  final FontWeight? fontWeight;
  final Widget? icon;
  final Color? edit;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        onPressed: onPress,
        child: Row(
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                  fontSize: 12, decoration: TextDecoration.underline, color: edit ?? color, fontWeight: fontWeight),
            ),
          ],
        ));
  }
}
