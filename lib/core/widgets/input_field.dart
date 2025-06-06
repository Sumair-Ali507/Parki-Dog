import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/widgets/weight_toggle.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.label,
    this.icon,
    this.suffix,
    this.onChanged,
    this.tapOnly = false,
    this.text,
    this.onTap,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.controller,
    this.filled = false,
  });

  final String label;
  final Widget? icon;
  final Widget? suffix;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  final bool tapOnly;
  final String? text;
  final Function()? onTap;

  final bool filled;

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      name: label,
      obscureText: obscureText,
      validator: validator,
      readOnly: tapOnly,
      onTap: onTap,
      initialValue: text,
      controller: controller,
      onChanged: onChanged,
      style: filled ? const TextStyle(fontSize: 32) : null,
      decoration: InputDecoration(
        filled: filled,
        fillColor: AppColors.secondary.withOpacity(0.2),
        contentPadding: filled ? const EdgeInsets.fromLTRB(18, 4, 0, 4) : null,

        isDense: true,
        errorMaxLines: 2,
        // Border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              BorderSide(color: filled ? Colors.transparent : Colors.black),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        // Icon
        prefixIcon: icon,
        prefixIconColor: AppColors.primary,
        suffixIcon: suffix,
        prefix: icon is WeightToggle ? const SizedBox(width: 8) : null,
        // Label
        labelText: label,
        labelStyle: const TextStyle(
          // fontSize: 12,
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
