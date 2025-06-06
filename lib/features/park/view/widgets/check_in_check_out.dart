import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
  CheckInCheckOut(
      {super.key,
      required this.park,
      required this.dogs,
      this.checkIn,
      this.checkOut});
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
        onPress: () async =>
            isPresent ? await _onCheckOut(context) : await _onCheckIn(context),
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
    TimeOfDay selectedTime = TimeOfDay.now();

    final TimeOfDay? pickedTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        DateTime tempPicked = DateTime.now();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Checking-In',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tell us when are you planning to leave the location.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat:
                        false, // 👈 this gives 12-hour format with AM/PM
                    initialDateTime: DateTime.now(),
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

    if (pickedTime == null) return;

    await context.read<ParkCubit>().checkInDog(
          park.id!,
          park.name!,
          userId,
          username,
          friends,
          Utils.timeOfDayToDateTime(pickedTime),
          checkIn,
        );
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
