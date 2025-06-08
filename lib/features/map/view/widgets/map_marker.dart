import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';

class MapMarker extends StatelessWidget {
  const MapMarker({super.key, required this.name, this.numberOfDogs, required this.zoom, this.checkedIn});
  final bool? checkedIn;
  final String name;
  final int? numberOfDogs;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/icon-max.png',
            width: 40,
          ),
          zoom > 13.5
              ? Column(
                  children: [
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIcons.bulldogSmall,
                        const SizedBox(width: 4),
                        Text(
                          '${numberOfDogs ?? 0} ${'dogs'.tr()}',
                          style: const TextStyle(fontSize: 12, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
