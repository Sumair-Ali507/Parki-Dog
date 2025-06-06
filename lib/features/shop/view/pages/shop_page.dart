import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/navigation/cubit/navigation_cubit.dart';
import 'package:parki_dog/features/shop/view/pages/search_screen.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../cubit/shop_cubit.dart';
import '../../data/item_model.dart';
import '../../data/shop_repository.dart';
import 'all_category_body_widget.dart';
import 'category_screen.dart';

class ShopScreen1 extends StatefulWidget {
  const ShopScreen1({Key? key}) : super(key: key);

  @override
  State<ShopScreen1> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen1> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: BlocBuilder<LangCubit, LangState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.black,
              dividerColor: Colors.black,
              labelPadding: const EdgeInsets.only(bottom: 10, right: 30),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(color: Colors.black),
              indicatorColor: Colors.black,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2),
              ),
              tabs: [
                Text('All categories'.tr()),
                Text('Food'.tr()),
                Text('Clothes'.tr()),
                Text('Toys'.tr()),
                Text('Other'.tr()),
              ],
            ),
            forceMaterialTransparency: true,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BlocBuilder<NavigationCubit, NavigationState>(builder: (context, state) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
                onPressed: () => context.read<NavigationCubit>().changeIndex(1),
              );
            }),
            title: Text(
              'Shop'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              // BlocBuilder<ShopCubit, ShopState>(builder: (context, state) {
              //   return GestureDetector(
              //     onTap: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(
              //           builder: (context) => const BagScreen(),
              //         ),
              //       );
              //     },
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Stack(
              //           fit: StackFit.loose,
              //           alignment: Alignment.bottomRight,
              //           children: [
              //             const Icon(
              //               Icons.shopping_bag,
              //               color: Colors.black,
              //               size: 30,
              //             ),
              //             ShopCubit.get(context).howManyItemInBag == 0
              //                 ? const SizedBox()
              //                 : Container(
              //                     width: 17,
              //                     height: 17,
              //                     decoration: const BoxDecoration(
              //                       color: Colors.red, // Change the color as needed
              //                       shape: BoxShape.circle,
              //                     ),
              //                     child: Center(
              //                       child: Text(
              //                         ShopCubit.get(context).howManyItemInBag.toString(),
              //                         style: const TextStyle(
              //                             color: Colors.white, // Change the text color as needed
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 10),
              //                       ),
              //                     ),
              //                   ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   );
              // }),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          body: StreamBuilder(
            stream: ShopRepository.db.collection('shop').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              ShopCubit.get(context).callOnce = 0;
              var shopQuerySnapshot = snapshot.data;
              List<ItemDetails>? shopCollection = (shopQuerySnapshot?.docs
                      .map((doc) => ItemDetails.fromJson(doc.data() as Map<String, dynamic>))
                      .toList()) ??
                  [];
              ShopCubit.get(context).sortShopItems(x: shopCollection);
              return TabBarView(
                controller: _tabController,
                children: [
                  AllCategoryScreen(
                    controller: _tabController,
                  ),
                  CategoryBodyScreen(itemDetails: ShopCubit.get(context).foodContainer),
                  CategoryBodyScreen(itemDetails: ShopCubit.get(context).clothesContainer),
                  CategoryBodyScreen(itemDetails: ShopCubit.get(context).toysContainer),
                  CategoryBodyScreen(itemDetails: ShopCubit.get(context).othersContainer),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
