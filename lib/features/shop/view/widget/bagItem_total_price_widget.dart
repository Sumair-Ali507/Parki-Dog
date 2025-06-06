import '../../data/item_model.dart';
import 'package:flutter/material.dart';

class BagItemMultiPrice extends StatelessWidget {
  final ItemDetails itemDetails;
  const BagItemMultiPrice({
    super.key,
    required this.itemDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${itemDetails.quantity} X ${itemDetails.name}'),
            Text('\$${itemDetails.quantity! * itemDetails.price}'),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
