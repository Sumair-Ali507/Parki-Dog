import 'package:flutter/material.dart';
import 'package:parki_dog/features/shop/cubit/shop_cubit.dart';

class ItemMultiView extends StatelessWidget {
  final List<String> imagePath;
  const ItemMultiView({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        imagePath.length,
        (index) => GestureDetector(
          onTap: () {
            ShopCubit.get(context).changeCarouselPosition(index: index);
          },
          child: Container(
            width: 70,
            height: 70,
            margin: const EdgeInsets.only(right: 4, left: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                imagePath[index],
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
