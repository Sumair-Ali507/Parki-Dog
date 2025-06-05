import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';

class PriceTagWidget extends StatelessWidget {
  final double price1;
  final double? price2;
  final double? price1Size;
  final double? price2Size;
  final Color? color1;
  final double? tagSize;
  final Color? tagColor;
  final bool? centerItem;
  const PriceTagWidget({
    super.key,
    required this.price1,
    required this.price2,
    this.price1Size,
    this.price2Size,
    this.color1,
    this.tagSize,
    this.tagColor,
    this.centerItem,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: centerItem ?? false ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        FaIcon(
          FontAwesomeIcons.tag,
          size: tagSize ?? 24,
          color: tagColor ?? AppColors.secondary,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          '\$$price1',
          style: TextStyle(
            fontSize: price1Size ?? 22,
            fontWeight: FontWeight.w600,
            color: color1 ?? AppColors.secondary,
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        price2 == 0 || price2 == null
            ? const SizedBox()
            : Text(
                '\$$price2',
                style: TextStyle(
                    fontSize: price2Size ?? 16,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey),
              ),
      ],
    );
  }
}
