import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/widgets/breed_selector.dart';
import 'package:parki_dog/core/widgets/input_field.dart';

import '../validators/form_validators.dart';

class BreedSelectorField extends StatelessWidget {
  const BreedSelectorField({super.key, this.selectionMode = 'single', this.initialValue});

  final String selectionMode;
  final List<String>? initialValue;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: initialValue?.join(', '));
    return InputField(
      label: selectionMode == 'single' ? 'Breed'.tr() : 'Breeds'.tr(),
      tapOnly: true,
      onTap: () async {
        final breed = await showModalBottomSheet(
          context: context,
          builder: (_) => BreedSelector(selectionMode: selectionMode, initialValue: initialValue),
          backgroundColor: Colors.black.withOpacity(0.6),
          isScrollControlled: true,
        );

        if (breed != null) {
          controller.value = TextEditingValue(text: breed as String);
        }
      },
      // text: 'ok',
      controller: controller,
      validator: selectionMode == 'single' ? FormValidators.required() : null,
    );
  }
}
