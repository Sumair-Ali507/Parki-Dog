import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../cubit/shop_cubit.dart';
import '../../cubit/shop_state.dart';
import '../widget/bagItem_total_price_widget.dart';
import '../widget/shop_button_widget.dart';

class BagScreen extends StatelessWidget {
  const BagScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          titleSpacing: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'My bag',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
        body: ShopCubit.get(context).bagContainer.isEmpty
            ? const Center(
                child: Text(
                  'No items in your bag.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              )
            : BlocConsumer<ShopCubit, ShopState>(
                listener: (BuildContext context, ShopState state) {},
                builder: (BuildContext context, ShopState state) {
                  var cubit = ShopCubit.get(context);
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 220),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 2.3 / 3, crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
                          shrinkWrap: true,
                          itemCount: cubit.bagContainer.length,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (context, index) => Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.itemBackGround,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(cubit.bagContainer[index].name),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              cubit.addItemToBag(itemDetails: cubit.bagContainer[index]);
                                            },
                                            child: const CircleAvatar(
                                              radius: 14,
                                              backgroundColor: AppColors.increDecreIcon,
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.black,
                                              ),
                                            )),
                                        Container(
                                          width: 60,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                                              border: Border.all()),
                                          child: Center(child: Text('${cubit.bagContainer[index].quantity!}')),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            cubit.removeItemFromBag(itemDetails: cubit.bagContainer[index]);
                                          },
                                          child: const CircleAvatar(
                                            radius: 14,
                                            backgroundColor: AppColors.increDecreIcon,
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Image.network(
                                      cubit.bagContainer[index].imagePath[0],
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                    ),
                                    Text('\$${cubit.bagContainer[index].price}'),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 5,
                                top: 5,
                                child: InkWell(
                                  onTap: () {
                                    cubit.removeAllOfThisItem(itemDetails: cubit.bagContainer[index]);
                                  },
                                  child: const Icon(
                                    Icons.delete_outline_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ShopCubit.get(context).bagContainer.isEmpty
                          ? const SizedBox()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 20, top: 10, left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset.fromDirection(1),
                                          color: Colors.grey,
                                          blurRadius: 10,
                                          spreadRadius: 2)
                                    ],
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(
                                              cubit.bagContainer.length,
                                              (index) => BagItemMultiPrice(
                                                itemDetails: cubit.bagContainer[index],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Total'),
                                          Text(
                                            '\$${cubit.totalItemsPrice}',
                                            style: const TextStyle(color: AppColors.secondary),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ShopButton(
                                        onTap: () {
                                          // ShopCubit.get(context).showPaymentButton(context: context);
                                        },
                                        showIcon: false,
                                        title: 'Checkout',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ],
                  );
                },
              ),
      );
    });
  }
}
