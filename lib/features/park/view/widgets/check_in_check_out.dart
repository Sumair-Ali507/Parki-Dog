import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/utils.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/data/friend_model.dart';
import 'package:parki_dog/features/home/data/park_model.dart';
import 'package:parki_dog/features/park/cubit/park_cubit.dart';
import 'package:parki_dog/features/park/view/widgets/time_picker.dart';

class CheckInCheckOut extends StatelessWidget {
  CheckInCheckOut({super.key, required this.park, required this.dogs, this.checkIn, this.checkOut});
  final Future<void> Function()? checkIn;
  final Future<void> Function()? checkOut;
  final ParkModel park;
  final List<DogModel> dogs;
  final String userId = GetIt.I.get<DogModel>().id!;
  final username = GetIt.I.get<DogModel>().name!;
  final List<FriendModel> friends = GetIt.I.get<DogModel>().friends;

  @override
  Widget build(BuildContext context) {
    final bool isPresent = _isDogInPark();

    return SizedBox(
      width: 120,
      child: PushButton(
        // autoCheckPress: isPresent ? checkOut : checkIn,
        text: isPresent ? 'Check out'.tr() : 'Check in'.tr(),
        textColor: Colors.white,
        fontSize: 11,
        icon: Icon(
          isPresent ? Icons.logout_rounded : Icons.login_rounded,
          size: 16,
          color: Colors.white,
        ),
        onPress: () async => isPresent ? await _onCheckOut(context) : await _onCheckIn(context),
        height: 32,
        fill: true,
        borderColor: Colors.transparent,
        color: AppColors.primary,
        borderRadius: 8,
      ),
    );
  }

  bool _isDogInPark() {
    return dogs.any((dog) => dog.id == userId);
  }

  Future<void> _onCheckIn(BuildContext context) async {
    TimeOfDay? leaveTime = await showModalBottomSheet(
      context: context,
      builder: (_) => TimePicker(title: 'When will you leave?'.tr()),
      backgroundColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
    );

    if (leaveTime == null) return;
    await context
        .read<ParkCubit>()
        .checkInDog(park.id!, park.name!, userId, username, friends, Utils.timeOfDayToDateTime(leaveTime), checkIn);
  }

  Future<void> _onCheckOut(BuildContext context) async {
    await context.read<ParkCubit>().checkOutDog(
          userId,
          park.id!,
        );
    if (checkOut != null) {
      await checkOut!();
    }
  }
}
