import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../shop/data/item_model.dart';
import '../../../shop/view/pages/item_details_screen.dart';
import '../../../shop/view/widget/price_tag_widget.dart';
import '../../../shop/view/widget/review_widget.dart';

class OneProduct extends StatelessWidget {
  const OneProduct({
    super.key,
    required this.itemDetails,
  });

  final ItemDetails itemDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ItemDetailsScreen(
              itemDetails: itemDetails,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10, top: 10),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: AppColors.itemBackGround,
              ),
              width: 110,
              height: 110,
              child: Center(
                child: Image.network(
                  itemDetails.imagePath[0],
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
            SizedBox(
              width: 90,
              child: Center(
                child: Text(
                  itemDetails.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            ReviewWidget(
              centerItem: true,
              showViewers: false,
              viewersTextSize: 10,
              showRate: false,
              rate: itemDetails.rate?.toDouble() ?? 0,
              viewersNumber: itemDetails.reviewsNumber?.toInt() ?? 0,
              iconSize: 12,
            ),
            PriceTagWidget(
              centerItem: true,
              tagColor: Colors.black,
              tagSize: 14,
              price1: itemDetails.price.toDouble(),
              color1: AppColors.primary,
              price1Size: 10,
              price2Size: 9,
              price2: itemDetails.price2?.toDouble(),
            ),
          ],
        ),
      ),
    );
  }
}
