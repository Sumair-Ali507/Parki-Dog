import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../cubit/shop_cubit.dart';
import '../widget/price_tag_widget.dart';
import '../widget/review_widget.dart';
import 'item_details_screen.dart';

class OnSearchBody extends StatelessWidget {
  const OnSearchBody({
    super.key,
    required this.cubit,
  });

  final ShopCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2.3 / 3, crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
        shrinkWrap: true,
        itemCount: cubit.searchContainer.length,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ItemDetailsScreen(
                  itemDetails: cubit.searchContainer[index],
                ),
              ),
            );
          },
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.itemBackGround,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Text(
                    cubit.searchContainer[index].name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                ReviewWidget(
                  centerItem: true,
                  showViewers: false,
                  viewersTextSize: 16,
                  showRate: false,
                  rate: cubit.searchContainer[index].rate?.toDouble() ?? 0,
                  viewersNumber: cubit.searchContainer[index].reviewsNumber?.toInt() ?? 0,
                  iconSize: 16,
                ),
                Image.network(
                  cubit.searchContainer[index].imagePath[0],
                  height: 110,
                  width: 110,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
                PriceTagWidget(
                  centerItem: true,
                  tagColor: Colors.black,
                  tagSize: 24,
                  price1: cubit.searchContainer[index].price.toDouble(),
                  color1: AppColors.primary,
                  price1Size: 18,
                  price2Size: 14,
                  price2: cubit.searchContainer[index].price2?.toDouble(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
