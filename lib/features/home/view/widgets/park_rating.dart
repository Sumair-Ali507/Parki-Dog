import 'package:flutter/material.dart';

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
        (index) => index < roundedRating
            ? const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 16,
              )
            : const Icon(
                Icons.star_border,
                size: 16,
              ),
      ),
    );
  }
}
