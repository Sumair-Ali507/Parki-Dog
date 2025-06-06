import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
  const ParkScreen(this.init,
      {super.key,
      this.checkIn,
      this.checkOut,
      this.result,
      this.parkImageList});

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
                body: SingleChildScrollView(
                  child: Center(
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
                                  SizedBox(
                                    width: 0.5.sw,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            park!.name!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w500,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ParkRating(
                                            rating: park!.rating,
                                            totalRatings:
                                                park!.userRatingsTotal),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Text(
                                        'Safe in 3 hours',
                                        style: TextStyle(
                                            color: Color(0xFFA00000),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assts/icons/bell-solid.svg'),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Text(
                                            'Notify me',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.black),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  ParkDistance(
                                    userLocation: locationCubit.location,
                                    parkLocation: LatLng(
                                        park!.location!.latitude,
                                        park!.location!.longitude),
                                  ),
                                  const SizedBox(width: 4),
                                  SvgPicture.asset(
                                      'assets/images/icons/bus.svg'),
                                  const SizedBox(width: 4),
                                  Text(
                                    '17m by by bus',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Directions button
                                  SizedBox(
                                    width: 215.w,
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Attaka, Suez Governorate..',
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      MapsLauncher.launchCoordinates(
                                          park!.location!.latitude,
                                          park!.location!.longitude);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(8.sp),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                            border: Border.all(
                                                color: AppColors.secondary)),
                                        width: 70.w,
                                        height: 40.h,
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.location),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Text('Go'),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Directions button
                                  SizedBox(
                                    width: 215.w,
                                    child: Row(
                                      children: [
                                        Icon(CupertinoIcons.clock),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '24 hours - ',
                                          style: TextStyle(),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Open Now',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 0.85.sw,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/paw.svg',
                                          colorFilter: ColorFilter.mode(
                                              Colors.black, BlendMode.srcIn),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Checked-in',
                                          style: TextStyle(),
                                        ),
                                        Spacer(),
                                        Text(
                                          dogs != null
                                              ? dogs!.length.toString()
                                              : '0',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black12,
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(16.h),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 60.w,
                                            height: 45.h,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  width: 40.w,
                                                  height: 40.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image.network(
                                                    'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?cs=srgb&dl=pexels-italo-melo-881954-2379004.jpg&fm=jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  left: 25,
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    width: 32.w,
                                                    height: 32.h,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2)),
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        'https://hips.hearstapps.com/clv.h-cdn.co/assets/16/18/gettyimages-586890581.jpg?crop=0.668xw:1.00xh;0.219xw,0&resize=980:*',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Afzal Khan'),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4.h,
                                                            horizontal: 8.w),
                                                    width: 40.w,
                                                    height: 25.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                      color: Color(0xFFEDFCF2),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Safe',
                                                        style: TextStyle(
                                                            fontSize: 9.sp,
                                                            color: Color(
                                                                0xFF099250)),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4.h,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/new-images/woman.svg'),
                                                  Text(
                                                    'Labrador Retriver',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xFF808086),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.more_horiz,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black12,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.all(16.sp),
                          width: 1.sw,
                          child: Expanded(
                            child: CheckInCheckOut(
                                park: park!,
                                dogs: dogs!,
                                checkIn: checkIn,
                                checkOut: checkOut),
                          ),
                        ),
                      ],
                    ),
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

  Widget _getParkSafetyStatus(
      List<DogModel> dogs, String parkId, BuildContext context) {
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
              onPress: () => context.read<ParkCubit>().subscribeToNotifications(
                  parkId, GetIt.I.get<DogModel>().unsocialWith!),
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

Widget buttonReview(final VoidCallback onPressed, final String text) =>
    ElevatedButton(
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
