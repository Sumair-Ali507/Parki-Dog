import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReviewWidget extends StatelessWidget {
  final double rate;
  final int viewersNumber;
  final bool showViewers;
  final double? iconSize;
  final bool? showRate;
  final double? viewersTextSize;
  final bool? centerItem;
  const ReviewWidget({
    super.key,
    required this.rate,
    required this.viewersNumber,
    required this.showViewers,
    this.iconSize,
    this.showRate,
    this.viewersTextSize,
    this.centerItem,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: centerItem ?? false ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            5,
            (index) => index + 1 - rate > 0
                ? Icon(
                    Icons.star_border,
                    size: iconSize ?? 24,
                  )
                : Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: iconSize ?? 24,
                  ),
          ),
        ),
        showRate ?? true
            ? Row(
                children: [
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    '${rate.toDouble()}',
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              )
            : const SizedBox(),
        const SizedBox(
          width: 5,
        ),
        showViewers
            ? Text(
                '($viewersNumber ${'reviews'.tr()})',
                style: TextStyle(fontSize: viewersTextSize ?? 16, color: Colors.grey),
              )
            : Text(
                '($viewersNumber)',
                style: TextStyle(fontSize: viewersTextSize ?? 16, color: Colors.grey),
              ),
      ],
    );
  }
}
