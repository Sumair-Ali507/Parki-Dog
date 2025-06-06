import 'package:flutter/material.dart';
import '../../../../core/utils/assets_manager.dart';

class ParkRating extends StatelessWidget {
  const ParkRating({super.key, required this.rating, required this.totalRatings});

  final double? rating;
  final int? totalRatings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildRating(),
        const SizedBox(width: 4),
        Text(
          '(${totalRatings ?? 0})',
          style: const TextStyle(fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildRating() {
    final roundedRating = rating?.round() ?? 0;

    return Row(
      children: List.generate(
        5,
            (index) => Image.asset(
          index < roundedRating
              ? ImageAssets.boneFilled
              : ImageAssets.boneOutlined,
          color: index < (rating ?? 0)
              ? Colors.amber // or your desired filled color
              : Colors.grey, // or your desired outline color
        ),
      ),
    );
  }
}