import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/view/widgets/coming_soon.dart';
import '../../../home/view/widgets/home_shop_wheel.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../data/item_model.dart';
import '../../data/shop_repository.dart';
import '../pages/category_screen.dart';
import 'home_shop.dart';

class DoggyShoppyWidget extends StatelessWidget {
  const DoggyShoppyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return StreamBuilder(
          stream: ShopRepository.db.collection('shop').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            var shopQuerySnapshot = snapshot.data;
            List<ItemDetails>? shopCollection =
                shopQuerySnapshot?.docs.map((doc) => ItemDetails.fromJson(doc.data() as Map<String, dynamic>)).toList();
            if (snapshot.connectionState == ConnectionState.active) {
              return HomeShopGrid(
                itemDetails: shopCollection!,
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const ComingSoon();
            }
          });
    });
  }
}
