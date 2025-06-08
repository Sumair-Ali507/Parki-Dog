import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/widgets/frost.dart';

class TimePicker extends StatelessWidget {
  const TimePicker({super.key, required this.title, this.initialTime});

  final String title;
  final TimeOfDay? initialTime;

  @override
  Widget build(BuildContext context) {
    return Frost(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: MediaQuery.of(context).size.height * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
            Theme(
              data: ThemeData.dark().copyWith(
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  confirmButtonStyle: TextButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(.5),
                    elevation: 0,
                  ),
                ),
                colorScheme: const ColorScheme.dark().copyWith(
                  primary: Colors.white,
                ),
                // textButtonTheme: TextButtonThemeData(
                //   style: ButtonStyle(
                //     maximumSize: MaterialStateProperty.resolveWith(
                //       (states) => const Size(0, 0),
                //     ),
                //     minimumSize: MaterialStateProperty.resolveWith(
                //       (states) => const Size(0, 0),
                //     ),
                //   ),
                // ),
              ),
              child: TimePickerDialog(
                initialTime: initialTime ?? TimeOfDay.now(),
                confirmText: 'Confirm'.tr(),
                helpText: '',
              ),
            ),
            // PushButton(
            //   text: 'OK',
            //   textColor: AppColors.secondary,
            //   borderColor: AppColors.secondary,
            //   onPress: () {},
            //   fill: false,
            //   color: Colors.transparent,
            // ),
          ],
        ),
      ),
    );
  }
}
