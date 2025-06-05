import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../home/view/widgets/google_ads.dart';
import '../../cubit/shop_cubit.dart';
import '../widget/shop_category_widget.dart';

class AllCategoryScreen extends StatelessWidget {
  final TabController controller;
  const AllCategoryScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: ListView(
        children: [
          ShopCategoryWidget(
            itemList: ShopCubit.get(context).foodContainer,
            category: 'Food'.tr(),
            onTap: () {
              controller.index = 1;
            },
          ),
          ShopCategoryWidget(
            itemList: ShopCubit.get(context).clothesContainer,
            category: 'Clothes'.tr(),
            onTap: () {
              controller.index = 2;
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: GoogleAdBanners(largeBanner: true)),
          ShopCategoryWidget(
            itemList: ShopCubit.get(context).toysContainer,
            category: 'Toys'.tr(),
            onTap: () {
              controller.index = 3;
            },
          ),
          ShopCategoryWidget(
            itemList: ShopCubit.get(context).othersContainer,
            category: 'Other'.tr(),
            onTap: () {
              controller.index = 4;
            },
          ),
        ],
      ),
    );
  }
}
