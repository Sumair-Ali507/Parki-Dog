import 'package:flutter/material.dart';
import 'package:parki_dog/core/theme/app_colors.dart';

class ShopButton extends StatelessWidget {
  final void Function() onTap;
  final bool showIcon;
  final String title;
  const ShopButton({
    super.key,
    required this.onTap,
    required this.showIcon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: AppColors.shopButtonColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 5,
            ),
            showIcon
                ? const Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
