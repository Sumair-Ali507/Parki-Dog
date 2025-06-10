import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/extensions/extenstions.dart';
import 'package:parki_dog/core/utils/assets_manager.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/text_styles.dart';
import 'package:parki_dog/core/utils/values_manager.dart';
import 'package:parki_dog/features/account/view/widgets/custom_input_field.dart';
import 'package:parki_dog/features/account/view/widgets/default_suffix_icon.dart';
import 'package:parki_dog/features/account/view/widgets/popup_menu_button.dart';
import 'package:parki_dog/generated/locale_keys.g.dart';

class GenderSelectionWidget extends StatelessWidget {
  final Function(Gender) onSelected;
  final TextEditingController genderController;
  const GenderSelectionWidget({
    super.key,
    required this.onSelected,
    required this.genderController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenuButton<Gender>(
      items: List.generate(
          Gender.values.length,
          (index) => CustomPopupMenuItem<Gender>(
                value: Gender.values[index],
                child: Container(
                  padding: const EdgeInsets.all(AppDouble.d16),
                  decoration: BoxDecoration(
                      color: ColorsManager.grey50,
                      borderRadius: BorderRadius.circular(AppDouble.d16)),
                  child: Text(
                    Gender.values[index].name.tr().capitalizeFirst(),
                    style: TextStyles.font16Grey700MediumRoboto(),
                  ),
                ),
              )),
      onSelected: onSelected,
      child: CustomInputField(
          hint: LocaleKeys.dogOwner_genderHint.tr(),
          label: LocaleKeys.dogOwner_gender.tr(),
          enabled: false,
          controller: genderController,
          // validator: validateRequiredField,
          suffixIcon: const DefaultSuffixIcon(assetName: ImageAssets.down)),
    );
  }
}

enum Gender {
  male(LocaleKeys.gender_gMale, AppInt.i1),
  female(LocaleKeys.gender_gFemale, AppInt.i2);

  const Gender(this.name, this.id);

  final String name;
  final int id;
}
Gender? parseGender(String? genderString) {
  switch (genderString?.toLowerCase()) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    default:
      return null; // Handle invalid input gracefully
  }
}

