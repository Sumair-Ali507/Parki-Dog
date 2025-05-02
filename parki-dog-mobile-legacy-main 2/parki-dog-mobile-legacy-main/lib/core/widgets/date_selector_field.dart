import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/validators/form_validators.dart';
import 'package:parki_dog/core/widgets/date_selector.dart';
import 'package:parki_dog/core/widgets/input_field.dart';

class DateSelectorField extends StatelessWidget {
  DateSelectorField({super.key, this.initialValue});

  late final TextEditingController _controller = TextEditingController();
  final DateTime? initialValue;

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      _controller.value = TextEditingValue(
        text: DateFormat('dd/MM/yyyy').format(initialValue!),
      );
    }

    return InputField(
      label: 'Date of Birth'.tr(),
      suffix: CustomIcons.calendar,
      tapOnly: true,
      onTap: () async {
        final date = await showModalBottomSheet(
          context: context,
          builder: (context) => DateSelector(initialValue: initialValue),
          backgroundColor: Colors.black.withOpacity(0.6),
          isScrollControlled: true,
        );

        if (date != null) {
          _controller.value = TextEditingValue(
            text: DateFormat('dd/MM/yyyy').format(date as DateTime),
          );
        }
      },
      // text: 'ok',
      controller: _controller,
      validator: FormValidators.required(),
    );
  }
}
