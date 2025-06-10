import 'dart:async';

import 'package:parki_dog/core/utils/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parki_dog/core/utils/values_manager.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool isDebounceEnabled;
  final bool obscureText;
  final TextInputType? textInputType;
  final String? hint;
  final String? label;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool enabled;
  final FocusNode? focusNode;
  final double textFontSize;
  final Color textColor;
  final BoxConstraints? prefixIconConstraints;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? focusedBorder;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final TextStyle? labelStyle;
  final String? helperText;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final Duration debounceDuration;

  const CustomInputField({
    super.key,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.textInputType,
    this.suffixIcon,
    required this.hint,
    this.label,
    this.readOnly = false,
    this.enabled = true,
    this.isDebounceEnabled = false,
    this.onChanged,
    this.focusNode,
    this.textFontSize = FontSize.s14,
    this.textColor = Colors.black,
    this.errorText,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.inputFormatters,
    this.focusedBorder,
    this.enabledBorder,
    this.border,
    this.labelStyle,
    this.helperText,
    this.fillColor = Colors.white,
    this.hintStyle,
    this.debounceDuration = const Duration(seconds: AppInt.i1),
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _debounceOnChanged(String value) {
    if (widget.onChanged == null) return; // Skip if onChanged is not provided

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onChanged!(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged:
          widget.isDebounceEnabled ? _debounceOnChanged : widget.onChanged,
      // onChanged: widget.onChanged,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: Colors.black,
      validator: widget.validator,
      controller: widget.controller,
      enabled: widget.enabled,
      keyboardType: widget.textInputType,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      style: Theme.of(context).inputDecorationTheme.hintStyle,
      decoration: InputDecoration(
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints,
        hintText: widget.hint,
        suffixIcon: widget.suffixIcon,
        labelText: widget.label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: widget.labelStyle,
        helperText: widget.helperText,
        fillColor: widget.fillColor,
        hintStyle: widget.hintStyle,
        filled: true,
        // hintStyle: ,
        // fillColor: ,
        // filled: ,
        border: widget.border,
        enabledBorder: widget.enabledBorder,
        focusedBorder: widget.focusedBorder,
        // errorBorder: ,
        // focusedErrorBorder: ,
        // disabledBorder: ,
      ),
    );
  }
}
