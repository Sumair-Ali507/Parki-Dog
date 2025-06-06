import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/utils.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/home/cubit/home_cubit.dart';
import 'package:parki_dog/features/home/view/widgets/compact_dogs.dart';
import 'package:parki_dog/features/map/cubit/map_cubit.dart';
import 'package:parki_dog/features/park/data/check_in_model.dart';
import 'package:parki_dog/features/park/view/widgets/time_picker.dart';

import '../../../../core/shared_widgets/svg_icon.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../../park/data/park_repository.dart';

class CurrentCheckIn extends StatelessWidget {
  const CurrentCheckIn({super.key});

  @override
  Widget build(BuildContext context) {
    final id = GetIt.instance.get<DogModel>().id;
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('dogs').doc(id).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data?.data() != null) {
              final dog = DogModel.fromMap(
                      snapshot.data?.data() as Map<String, dynamic>)
                  .copyWith(id: id);
              GetIt.instance.registerSingleton<DogModel>(dog);
            }

            if (snapshot.data?.data() != null &&
                snapshot.data?.data()?['currentCheckIn'] != null) {
              final checkIn = snapshot.data?.data()?['currentCheckIn'];
              final homeCubit = context.read<HomeCubit>();

              return FutureBuilder(
                future: homeCubit
                    .getCurrentCheckInDetails(CheckInModel.fromMap(checkIn)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    ParkRepository.parkDetails(parkId: snapshot.data!.parkId)
                        .whenComplete(() => context
                            .read<MapCubit>()
                            .checkInHomePark(
                                iD: snapshot.data!.parkId,
                                singleParkModel:
                                    ParkRepository.singleParkModel!));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'My Current Check-in'.tr(),
                        //   style: const TextStyle(
                        //       fontSize: 16, fontWeight: FontWeight.w600),
                        // ),
                        // const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xffF8F5FF), // Updated color
                          ),
                          child: Column(
                            children: [
                              // Current Location and Leaving Time Row
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgIcon(
                                              assetName:
                                                  ImageAssets.locationPin,
                                              color:
                                                  ColorsManager.primaryColor),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Current Location'.tr(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.primary),
                                              ),
                                              const SizedBox(height: 3),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.32,
                                                child: Text(
                                                  snapshot.data!.parkName,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.primary),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SvgIcon(
                                              assetName: ImageAssets.clock,
                                              color:
                                                  ColorsManager.primaryColor),
                                          SizedBox(width: AppDouble.d8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Leaving Time'.tr(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.primary),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                DateFormat.jm().format(
                                                    snapshot.data!.leaveTime),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primary),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 32,
                                thickness: 1,
                                color:
                                    Color(0xffE5E5E5), // Updated divider color
                              ),
                              // Checked-in Dogs Row
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SvgIcon(
                                              assetName: ImageAssets.animalLeg,
                                              color:
                                                  ColorsManager.primaryColor),
                                          const SizedBox(width: AppDouble.d8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Checked-in Dogs'.tr(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  CompactDogs(snapshot
                                                      .data!.checkedInDogs),
                                                  Text(
                                                    'other dogs'.plural(snapshot
                                                        .data!
                                                        .checkedInDogs
                                                        .length),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ElevatedButton.icon(
                                    //   style: ElevatedButton.styleFrom(
                                    //     backgroundColor: const Color(0xffFFEBEB), // Red background
                                    //     shape: const StadiumBorder(),
                                    //   ),
                                    //   onPressed: () => Navigator.pushNamed(
                                    //       context,
                                    //       '/home/current-checkin/dogs',
                                    //       arguments: snapshot.data!.checkedInDogs
                                    //   ),
                                    //  // icon: CustomIcons., // You might need to add this icon
                                    //   label: Text(
                                    //     'Signal Dogs'.tr(),
                                    //     style: const TextStyle(
                                    //       fontSize: 14,
                                    //       color: Color(0xffFF5A5A), // Red text
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 32,
                                thickness: 1,
                                color:
                                    Color(0xffE5E5E5), // Updated divider color
                              ),
                              // Check Out and Extend Time Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => _onCheckOut(
                                          context, snapshot.data!.parkId),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shape: const StadiumBorder(),
                                        side: const BorderSide(
                                          color:
                                              Color(0xffD9D9D9), // Grey border
                                          width: 1,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                      child: Text(
                                        'Check out'.tr(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _onExtend(
                                          context,
                                          snapshot.data!.parkId,
                                          snapshot.data!.leaveTime),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: const StadiumBorder(),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                      child: Text(
                                        'Extend time'.tr(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            }
            return const SizedBox.shrink();
          });
    });
  }

  Future<void> _onExtend(
    BuildContext context,
    String parkId,
    DateTime currentLeaveTime,
  ) async {
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(currentLeaveTime);

    final TimeOfDay? leaveTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        DateTime tempPicked = currentLeaveTime;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Extend Time',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tell us your new leaving time.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: false, // 👈 for 12-hour AM/PM format
                    initialDateTime: currentLeaveTime,
                    onDateTimeChanged: (DateTime newTime) {
                      tempPicked = newTime;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        TimeOfDay.fromDateTime(tempPicked),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B35F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (leaveTime == null) return;

    await context.read<HomeCubit>().extendTime(
          GetIt.instance.get<DogModel>().id!,
          parkId,
          Utils.timeOfDayToDateTime(leaveTime),
          currentLeaveTime,
        );
  }

  Future<void> _onCheckOut(BuildContext context, String parkId) async {
    await context.read<HomeCubit>().checkOutDog(
          GetIt.instance.get<DogModel>().id!,
          parkId,
        );
    await ParkRepository.deleteMarker(parkId);
  }
}
