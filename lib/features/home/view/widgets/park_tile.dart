import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:parki_dog/core/navigation/cubit/navigation_cubit.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/features/home/data/park_model.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';
import 'package:parki_dog/features/home/view/widgets/park_distance.dart';
import 'package:parki_dog/features/home/view/widgets/park_rating.dart';
import 'package:parki_dog/features/park/data/park_repository.dart';
import 'package:parki_dog/features/park/view/pages/park_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '../../../map/cubit/map_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParkTile extends StatelessWidget {
  const ParkTile(this.park, {super.key, required this.userLocation});

  final ParkModel park;
  final LatLng userLocation;

  @override
  Widget build(BuildContext context) {
    final ParkDistance distanceWidget = ParkDistance(
      userLocation: userLocation,
      parkLocation: LatLng(park.location!.latitude, park.location!.longitude),
    );
    return ListTile(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          },
        );
        await ParkRepository.parkDetails(parkId: park.id!).whenComplete(() {
          Navigator.of(context).pop();
          if (ParkRepository.singleParkModel != null) {
            context.read<NavigationCubit>().showBottomSheet(
                  ParkScreen(
                    () => ParkModel(
                      name: ParkRepository.singleParkModel?.result?.name,
                      id: ParkRepository.singleParkModel?.result?.placeId,
                      location: GeoPoint(ParkRepository.singleParkModel!.result!.geometry!.location!.lat!,
                          ParkRepository.singleParkModel!.result!.geometry!.location!.lng!),
                      numberOfDogs: 0,
                      photoUrl: '',
                      photoReference: '',
                      userRatingsTotal: ParkRepository.singleParkModel?.result?.userRatingsTotal,
                      rating: ParkRepository.singleParkModel?.result?.rating?.toDouble(),
                    ),
                    result: ParkRepository.singleParkModel?.result,
                    parkImageList: ParkRepository.parkImageList,
                    checkIn: () async => await context
                        .read<MapCubit>()
                        .checkInHomePark(iD: park.id!, singleParkModel: ParkRepository.singleParkModel!),
                    checkOut: () async => await context
                        .read<MapCubit>()
                        .checkOutPark(position: gmaps.LatLng(park.location!.latitude, park.location!.longitude)),
                  ),
                );
          } else {
            print("singleParkModel is not initialized.");
          }
        });
      },
      horizontalTitleGap: 8,
      contentPadding: EdgeInsets.zero,
      leading: Avatar(park.photoUrl, radius: 21, hasStatus: false),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                park.name!,
                style: const TextStyle(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ParkRating(rating: park.rating ?? 0, totalRatings: park.userRatingsTotal ?? 0),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          distanceWidget,
          const SizedBox(width: 4),
          CustomIcons.bulldogSmall,
          const SizedBox(width: 4),
          Text(
            '${park.numberOfDogs} ${'dogs'.tr()}',
            style: const TextStyle(fontSize: 14, color: AppColors.primary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.black,
      ),
    );
  }
}
