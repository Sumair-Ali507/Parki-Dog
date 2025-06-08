import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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
          stream: FirebaseFirestore.instance.collection('dogs').doc(id).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data?.data() != null) {
              final dog = DogModel.fromMap(snapshot.data?.data() as Map<String, dynamic>).copyWith(id: id);

              GetIt.instance.registerSingleton<DogModel>(dog);
            }

            if (snapshot.data?.data() != null && snapshot.data?.data()?['currentCheckIn'] != null) {
              final checkIn = snapshot.data?.data()?['currentCheckIn'];
              final homeCubit = context.read<HomeCubit>();

              return FutureBuilder(
                future: homeCubit.getCurrentCheckInDetails(CheckInModel.fromMap(checkIn)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    ParkRepository.parkDetails(parkId: snapshot.data!.parkId).whenComplete(() => context
                        .read<MapCubit>()
                        .checkInHomePark(iD: snapshot.data!.parkId, singleParkModel: ParkRepository.singleParkModel!));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Current Check-in'.tr(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xfff2f2f2),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomIcons.mapPin,
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Current Location'.tr(),
                                            style: const TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.primary),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.40,
                                            child: Text(
                                              snapshot.data!.parkName,
                                              style: const TextStyle(
                                                  fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomIcons.clock,
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Leaving Time'.tr(),
                                            style: const TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.primary),
                                          ),
                                          Text(
                                            DateFormat.jm().format(snapshot.data!.leaveTime),
                                            style: const TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomIcons.bulldogLarge,
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Checked-in Dogs'.tr(),
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                          ),
                                          CompactDogs(snapshot.data!.checkedInDogs),
                                        ],
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(context, '/home/current-checkin/dogs',
                                        arguments: snapshot.data!.checkedInDogs),
                                    child: Row(
                                      children: [
                                        Text(
                                          'View all'.tr(),
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: PushButton(
                                      text: 'Check out'.tr(),
                                      onPress: () => _onCheckOut(context, snapshot.data!.parkId),
                                      height: 40,
                                      borderRadius: 8,
                                      fill: false,
                                      color: Colors.transparent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: PushButton(
                                      text: 'Extend time'.tr(),
                                      onPress: () =>
                                          _onExtend(context, snapshot.data!.parkId, snapshot.data!.leaveTime),
                                      height: 40,
                                      borderRadius: 8,
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w500,
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

  Future<void> _onExtend(BuildContext context, String parkId, DateTime currentLeaveTime) async {
    TimeOfDay? leaveTime = await showModalBottomSheet(
      context: context,
      builder: (_) => TimePicker(title: 'Extend time'.tr(), initialTime: Utils.dateTimeToTimeOfDay(currentLeaveTime)),
      backgroundColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
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
