import 'package:flutter/material.dart';

class PushButton extends StatelessWidget {
  const PushButton({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.color,
    this.textColor,
    this.fontWeight,
    this.borderRadius = 16,
    this.height = 48,
    this.icon,
    this.fill = true,
    this.borderColor = const Color(0xffD2D2D2),
    required this.onPress,
    this.autoCheckPress,
  });

  final String text;
  final double fontSize;
  final Color? color;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double borderRadius;
  final double height;
  final Widget? icon;
  final bool fill;
  final Color borderColor;
  final Function() onPress;
  final Future<void> Function()? autoCheckPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: autoCheckPress,
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          backgroundColor: color != null ? MaterialStateProperty.all(color) : null,
          elevation: MaterialStateProperty.all(0),
          fixedSize: MaterialStateProperty.all(Size(double.maxFinite, height)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(
                style: fill ? BorderStyle.none : BorderStyle.solid,
                color: borderColor,
              ),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox.shrink(),
            icon != null ? const SizedBox(width: 4) : const SizedBox.shrink(),
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
