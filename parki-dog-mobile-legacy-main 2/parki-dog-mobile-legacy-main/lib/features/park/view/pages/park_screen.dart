import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:parki_dog/core/services/location/cubit/location_cubit.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/view/widgets/link_button.dart';
import 'package:parki_dog/features/home/data/park_model.dart';
import 'package:parki_dog/features/home/view/widgets/park_distance.dart';
import 'package:parki_dog/features/home/view/widgets/park_rating.dart';
import 'package:parki_dog/features/park/cubit/park_cubit.dart';
import 'package:parki_dog/features/park/view/widgets/carousel.dart';
import 'package:parki_dog/features/park/view/widgets/check_in_check_out.dart';
import 'package:parki_dog/features/park/view/widgets/checked_in_dogs.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../../shop/view/pages/web_view.dart';
import '../../data/single_park_model.dart';

class ParkScreen extends StatelessWidget {
  const ParkScreen(this.init, {super.key, this.checkIn, this.checkOut, this.result, this.parkImageList});

  final Function() init;
  final Future<void> Function()? checkIn;
  final Future<void> Function()? checkOut;
  final Result? result;
  final List<String>? parkImageList;
  @override
  Widget build(BuildContext context) {
    final locationCubit = context.watch<LocationCubit>();
    ParkModel? park;
    List<DogModel>? dogs;

    return BlocProvider<ParkCubit>(
      create: (context) => ParkCubit(init)..getParkData(),
      child: BlocConsumer<ParkCubit, ParkState>(
        listener: (context, state) {
          if (state is ParkError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is ParkLoaded) {
            park = state.park;
            dogs = state.checkedInDogs;
          }

          if (state is CheckedInDog || state is CheckedOutDog) {
            Navigator.pop(context);
          }
        },
        buildWhen: (previous, current) => current is ParkLoaded,
        builder: (context, state) {
          if (park != null) {
            return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
              return Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      Carousel(photoUrls: parkImageList ?? [park!.photoUrl]),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    park!.name!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ParkRating(rating: park!.rating, totalRatings: park!.userRatingsTotal),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ParkDistance(
                              userLocation: locationCubit.location,
                              parkLocation: LatLng(park!.location!.latitude, park!.location!.longitude),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                // Directions button
                                ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: 125, maxWidth: 135),
                                  child: PushButton(
                                    text: 'Directions'.tr(),
                                    textColor: AppColors.primary,
                                    fontSize: 11,
                                    icon: const Icon(
                                      CupertinoIcons.location,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    onPress: () {
                                      MapsLauncher.launchCoordinates(
                                          park!.location!.latitude, park!.location!.longitude);
                                    },
                                    height: 32,
                                    fill: false,
                                    borderColor: AppColors.primary,
                                    color: Colors.transparent,
                                    borderRadius: 8,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Check in button
                                CheckInCheckOut(park: park!, dogs: dogs!, checkIn: checkIn, checkOut: checkOut),
                                const Spacer(),

                                // Park safety status
                                _getParkSafetyStatus(dogs!, park!.id!, context),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CheckedInDogs(dogs ?? []),
                          ],
                        ),
                      ),
                      Expanded(
                          child: ListView(
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 16),
                          result?.reviews?.isEmpty ?? true
                              ? Center(child: Text('No Reviews'.tr()))
                              : Column(
                                  children: List.generate(
                                    result?.reviews?.length ?? 0,
                                    (index) => Container(
                                      padding: const EdgeInsets.all(8.0),
                                      margin: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20.0,
                                                backgroundImage:
                                                    NetworkImage(result?.reviews?[index].profilePhotoUrl ?? ''),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    result?.reviews?[index].authorName ?? '',
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    result?.reviews?[index].relativeTimeDescription ?? '',
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              Text('${result?.reviews?[index].rating ?? 0}/5'),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(result?.reviews?[index].text ?? ''),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      )),
                      buttonReview(() {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WebView(
                            url: result?.url ?? '',
                            itemName: result?.name ?? '',
                          ),
                        ));
                      }, 'Review us'.tr()),
                    ],
                  ),
                ),
              );
            });
          }

          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }

  Widget _getParkSafetyStatus(List<DogModel> dogs, String parkId, BuildContext context) {
    DateTime? timeForSafety;

    for (var dog in dogs) {
      if (dog.isSafe == false) {
        final leaveTime = dog.currentCheckIn!.leaveTime;

        if (timeForSafety == null || leaveTime.isAfter(timeForSafety)) {
          timeForSafety = leaveTime;
        }
      }
    }

    if (timeForSafety == null) {
      return Text(
        'Safe'.tr(),
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xff06851A),
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Column(
      children: [
        Text(
          _getSafeIn(timeForSafety),
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xffA00000),
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            CustomIcons.bellRinging,
            const SizedBox(width: 4),
            LinkButton(
              text: 'Notify Me'.tr(),
              onPress: () =>
                  context.read<ParkCubit>().subscribeToNotifications(parkId, GetIt.I.get<DogModel>().unsocialWith!),
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }

  String _getSafeIn(DateTime timeForSafety) {
    final difference = timeForSafety.difference(DateTime.now());

    if (difference.inHours > 0) {
      return '${'Safe in'.tr()} ${difference.inHours} hrs';
    }

    return '${'Safe in'.tr()} ${difference.inMinutes} mins';
  }
}

Widget buttonReview(final VoidCallback onPressed, final String text) => ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        backgroundColor: AppColors.primary, // Button color
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color
        ),
      ),
    );
