import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.placeholder,
    required this.onChanged,
    this.color,
    this.textColor = Colors.white,
    this.borderColor = Colors.white,
    this.focusNode,
    this.controller,
  });

  final String placeholder;
  final Function(String) onChanged;
  final Color? color;
  final Color textColor;
  final Color borderColor;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: CupertinoSearchTextField(
        controller: controller,
        focusNode: focusNode,
        placeholder: placeholder,
        placeholderStyle: TextStyle(color: textColor),
        prefixInsets: const EdgeInsets.only(left: 16),
        style: TextStyle(
          color: textColor,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
          ),
        ),
        itemColor: textColor,
        onChanged: onChanged,
      ),
    );
  }
}
