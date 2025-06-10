import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parki_dog/core/extensions/extenstions.dart';

import 'package:parki_dog/core/utils/text_styles.dart';
import 'package:parki_dog/core/utils/values_manager.dart';
import 'package:parki_dog/features/account/cubit/date_selection_cubit.dart';
import 'package:parki_dog/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectDatetimePopup extends StatelessWidget {
  final bool isDatePickerMode;
  final String? subTitle;
  final DateTime? maximumDate;
  final Function(DateTime) onDateTimeChanged;

  const SelectDatetimePopup(
      {super.key,
      required this.isDatePickerMode,
      this.subTitle,
      this.maximumDate,
      required this.onDateTimeChanged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DateSelectionCubit(),
      child: BlocBuilder<DateSelectionCubit, DateTime>(
        builder: (selectContext, selectedDateTime) {
          return SizedBox(
            width: AppDouble.d1.sw,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (subTitle != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppDouble.d17),
                    child: Text(
                      subTitle!,
                      style: TextStyles.font14Grey400Regular(),
                    ).tr(),
                  ),
                SizedBox(
                  height: AppDouble.d200,
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    mode: isDatePickerMode
                        ? CupertinoDatePickerMode.date
                        : CupertinoDatePickerMode.time,
                    use24hFormat: false,
                    maximumDate: maximumDate ?? DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) {
                      selectContext
                          .read<DateSelectionCubit>()
                          .updateSelectedDate(newDate);
                    },
                  ),
                ),
                const SizedBox(height: AppDouble.d16),
                SizedBox(
                  width: AppDouble.d1.sw,
                  child: ElevatedButton(
                      onPressed: () {
                        onDateTimeChanged.call(selectedDateTime);
                        context.pop();
                      },
                      child: const Text(LocaleKeys.dateAndTimePicker_confirm)
                          .tr()),
                ),
                const SizedBox(height: AppDouble.d12),
                SizedBox(
                  width: AppDouble.d1.sw,
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      LocaleKeys.dateAndTimePicker_cancel,
                      style: TextStyles.font16Grey600Medium(),
                    ).tr(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
