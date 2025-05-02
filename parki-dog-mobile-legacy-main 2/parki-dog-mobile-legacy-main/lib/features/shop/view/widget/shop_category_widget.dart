import 'package:flutter/material.dart';
import 'package:parki_dog/features/shop/view/widget/price_tag_widget.dart';
import 'package:parki_dog/features/shop/view/widget/review_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/item_model.dart';
import '../pages/item_details_screen.dart';

class ShopCategoryWidget extends StatelessWidget {
  final List<ItemDetails> itemList;
  final String category;
  final void Function() onTap;
  const ShopCategoryWidget({
    super.key,
    required this.itemList,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return itemList.isEmpty
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    category,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  InkWell(onTap: onTap, child: const Icon(Icons.arrow_forward)),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ItemDetailsScreen(
                              itemDetails: itemList[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: AppColors.itemBackGround,
                              ),
                              width: 90,
                              height: 90,
                              child: Center(
                                child: Image.network(
                                  itemList[index].imagePath[0],
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 90,
                                child: Center(
                                  child: Text(
                                    itemList[index].name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )),
                            ReviewWidget(
                              showViewers: false,
                              viewersTextSize: 10,
                              showRate: false,
                              rate: itemList[index].rate?.toDouble() ?? 0,
                              viewersNumber: itemList[index].reviewsNumber?.toInt() ?? 0,
                              iconSize: 10,
                            ),
                            PriceTagWidget(
                              tagColor: Colors.black,
                              tagSize: 12,
                              price1: itemList[index].price.toDouble(),
                              color1: AppColors.primary,
                              price1Size: 12,
                              price2Size: 10,
                              price2: itemList[index].price2?.toDouble(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
