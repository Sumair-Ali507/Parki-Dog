import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../shop/data/item_model.dart';
import '../../../shop/view/pages/item_details_screen.dart';
import '../../../shop/view/widget/price_tag_widget.dart';
import '../../../shop/view/widget/review_widget.dart';
import 'one_product_wheel.dart';

class HomeShoppingWheel extends StatelessWidget {
  const HomeShoppingWheel({
    super.key,
    required this.itemDetails,
  });
  final List<ItemDetails> itemDetails;

  @override
  Widget build(BuildContext context) {
    return itemDetails.isEmpty
        ? const SizedBox()
        : SizedBox(
            height: 200,
            child: ListWheelScrollView(
              itemExtent: 175,
              children: List.generate(
                (itemDetails.length / 3).ceil(),
                (index) {
                  return Row(
                    children: [
                      if (itemDetails.elementAtOrNull((index * 3)) != null)
                        OneProduct(itemDetails: itemDetails[index * 3]),
                      if (itemDetails.elementAtOrNull((index * 3 + 1)) != null)
                        OneProduct(itemDetails: itemDetails[index * 3 + 1]),
                      if (itemDetails.elementAtOrNull((index * 3 + 2)) != null)
                        OneProduct(itemDetails: itemDetails[index * 3 + 2]),
                    ],
                  );
                },
              ),
            ),
          );
  }
}
