import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/features/shop/cubit/shop_state.dart';
import 'package:parki_dog/features/shop/view/pages/search_screen.dart';
import 'package:parki_dog/features/shop/view/pages/web_view.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../cubit/shop_cubit.dart';
import '../../data/item_model.dart';
import '../widget/item_mutli_view_widget.dart';
import '../widget/price_tag_widget.dart';
import '../widget/review_widget.dart';
import '../widget/shop_button_widget.dart';
import 'bag_screen.dart';

class ItemDetailsScreen extends StatelessWidget {
  final ItemDetails itemDetails;
  const ItemDetailsScreen({Key? key, required this.itemDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop()),
          title: Text(
            'Shop'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          actions: [
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => WebView(
            //           url: itemDetails.viewLink ?? '',
            //           itemName: itemDetails.name,
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Icon(
            //     Icons.view_carousel_outlined,
            //     color: Colors.black,
            //     size: 30,
            //   ),
            // ),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<ShopCubit, ShopState>(builder: (context, state) {
                      return CarouselSlider(
                        carouselController: ShopCubit.get(context).carouselController,
                        items: List.generate(
                          itemDetails.imagePath.length,
                          (index) => Image.network(
                            itemDetails.imagePath[index],
                            height: 230,
                            width: 230,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),
                        options: CarouselOptions(
                          initialPage: 0,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          height: 230,
                          aspectRatio: 1 / 1,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: false,
                          viewportFraction: 1.0,
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 4,
                    ),
                    ItemMultiView(
                      imagePath: itemDetails.imagePath,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      itemDetails.name,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PriceTagWidget(
                      price1: itemDetails.price.toDouble(),
                      price2: itemDetails.price2?.toDouble(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      itemDetails.description ?? '',
                      style: const TextStyle(height: 2, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReviewWidget(
                      rate: itemDetails.rate?.toDouble() ?? 0,
                      viewersNumber: itemDetails.reviewsNumber?.toInt() ?? 0,
                      showViewers: true,
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShopButton(
                    onTap: () {
                      // ShopCubit.get(context).addItemToBag(itemDetails: itemDetails);
                      //ShopCubit.get(context).showToaster();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WebView(
                            url: itemDetails.viewLink ?? '',
                            itemName: itemDetails.name,
                          ),
                        ),
                      );
                    },
                    showIcon: true,
                    title: 'Go to product'.tr(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
