import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/item_model.dart';
import '../pages/item_details_screen.dart';
import '../widget/price_tag_widget.dart';
import '../widget/review_widget.dart';

class HomeShopGrid extends StatelessWidget {
  const HomeShopGrid({
    super.key,
    required this.itemDetails,
  });
  final List<ItemDetails> itemDetails;

  @override
  Widget build(BuildContext context) {
    return itemDetails.isEmpty
        ? const SizedBox()
        : SizedBox(
            height: 12 > 6 ? 260 : null,
            child: GridView.builder(
              physics: itemDetails.length > 6 ? null : const NeverScrollableScrollPhysics(),
              clipBehavior: Clip.hardEdge,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (0.65 / 0.8), crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
              shrinkWrap: true,
              itemCount: itemDetails.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ItemDetailsScreen(
                        itemDetails: itemDetails[index],
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
                        width: 75,
                        height: 75,
                        child: Center(
                          child: Image.network(
                            itemDetails[index].imagePath[0],
                            height: 70,
                            width: 70,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Center(
                          child: Text(
                            itemDetails[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      ReviewWidget(
                        centerItem: true,
                        showViewers: false,
                        viewersTextSize: 6,
                        showRate: false,
                        rate: itemDetails[index].rate?.toDouble() ?? 0,
                        viewersNumber: itemDetails[index].reviewsNumber?.toInt() ?? 0,
                        iconSize: 12,
                      ),
                      PriceTagWidget(
                        centerItem: true,
                        tagColor: Colors.black,
                        tagSize: 14,
                        price1: itemDetails[index].price.toDouble(),
                        color1: AppColors.primary,
                        price1Size: 10,
                        price2Size: 9,
                        price2: itemDetails[index].price2?.toDouble(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
