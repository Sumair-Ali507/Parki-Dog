import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/view/widgets/google_ads.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../data/item_model.dart';
import '../widget/price_tag_widget.dart';
import '../widget/review_widget.dart';
import 'item_details_screen.dart';

class CategoryBodyScreen extends StatelessWidget {
  const CategoryBodyScreen({
    super.key,
    required this.itemDetails,
    this.scrollable,
    this.horizontalScroll,
  });
  final bool? horizontalScroll;
  final bool? scrollable;
  final List<ItemDetails> itemDetails;

  @override
  Widget build(BuildContext context) {
    return itemDetails.isEmpty
        ? const SizedBox()
        : BlocBuilder<LangCubit, LangState>(builder: (context, state) {
            return Scaffold(
              body: SizedBox(
                child: GridView.builder(
                  scrollDirection: horizontalScroll ?? false ? Axis.horizontal : Axis.vertical,
                  physics: scrollable ?? true ? null : const NeverScrollableScrollPhysics(),
                  clipBehavior: Clip.hardEdge,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: horizontalScroll ?? false ? (0.65 / 0.8) : (0.9 / 1.7),
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
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
                            width: horizontalScroll ?? false ? 75 : 110,
                            height: horizontalScroll ?? false ? 75 : 110,
                            child: Center(
                              child: Image.network(
                                itemDetails[index].imagePath[0],
                                height: horizontalScroll ?? false ? 70 : 100,
                                width: horizontalScroll ?? false ? 70 : 100,
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
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: horizontalScroll ?? false ? 10 : 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          ReviewWidget(
                            centerItem: true,
                            showViewers: false,
                            viewersTextSize: horizontalScroll ?? false ? 6 : 10,
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
              ),
              floatingActionButton: const Padding(
                  padding: EdgeInsets.only(left: 30, right: 10, bottom: 50), child: GoogleAdBanners(largeBanner: true)),
            );
          });
  }
}
