import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/widgets/frost.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../features/lang/lang_cubit.dart';
import '../../features/lang/lang_state.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key, this.initialValue});
  final DateTime? initialValue;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialValue ?? DateTime.now();
  }

  void _onDateChange(DateTime value) {
    setState(() {
      selectedDate = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Frost(
      child: BlocBuilder<LangCubit, LangState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.6),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(24, 70, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date of birth',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 48, 0, 8),
                  child: Text(DateFormat('EEE, MMM d').format(selectedDate),
                      style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500)),
                ),
                const Divider(
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 1.1,
                    child: SfDateRangePicker(
                      onSelectionChanged: (date) => {_onDateChange(date.value)},
                      initialSelectedDate: selectedDate,
                      initialDisplayDate: selectedDate,
                      maxDate: DateTime.now(),
                      showNavigationArrow: true,
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                        viewHeaderHeight: 64,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      selectionColor: Colors.white,
                      selectionTextStyle: const TextStyle(color: Colors.black),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: const TextStyle(color: Colors.white),
                        todayTextStyle: const TextStyle(color: Colors.white),
                        todayCellDecoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        disabledDatesTextStyle: const TextStyle(color: Colors.grey),
                      ),
                      yearCellStyle: const DateRangePickerYearCellStyle(
                        textStyle: TextStyle(color: Colors.white),
                        todayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                        todayCellDecoration: BoxDecoration(),
                        disabledDatesTextStyle: TextStyle(color: Colors.grey),
                      ),
                      headerStyle: const DateRangePickerHeaderStyle(
                        textStyle: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: PushButton(
                    text: 'OK',
                    textColor: AppColors.secondary,
                    borderColor: AppColors.secondary,
                    onPress: () => Navigator.pop(context, selectedDate),
                    fill: false,
                    color: Colors.transparent,
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: Container(
              padding: EdgeInsets.zero,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Frost(
                child: FloatingActionButton.small(
                  elevation: 0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(
                    side: BorderSide(color: Colors.white),
                  ),
                  child: const Icon(Icons.close),
                ),
              ),
            ),
          ),
          extendBody: true,
        );
      }),
    );
  }
}
