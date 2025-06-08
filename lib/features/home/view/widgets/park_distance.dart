import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/utils.dart';

class ParkDistance extends StatelessWidget {
  const ParkDistance({
    super.key,
    required this.userLocation,
    required this.parkLocation,
  });

  final LatLng userLocation;
  final LatLng parkLocation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIcons.mapPin,
        const SizedBox(width: 4),
        Text(
          '${(Utils.getDistance(userLocation, LatLng(parkLocation.latitude, parkLocation.longitude)) / 1000).toStringAsFixed(1)}km ${'away'.tr()}',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
