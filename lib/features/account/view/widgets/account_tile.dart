import 'package:flutter/material.dart';
import 'package:parki_dog/core/theme/app_colors.dart';

class AccountTile extends StatelessWidget {
  const AccountTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  final Widget icon;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 36, vertical: 4),
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
      onTap: onTap,
    );
  }
}
