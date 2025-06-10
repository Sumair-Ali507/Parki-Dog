import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/extensions/extenstions.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/utils/assets_manager.dart';
import 'package:parki_dog/core/validators/form_validators.dart';
import 'package:parki_dog/core/widgets/date_selector_field.dart';
import 'package:parki_dog/core/widgets/gender_selector.dart';
import 'package:parki_dog/core/widgets/input_field.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/account/cubit/edit_basic_info_cubit.dart';
import 'package:parki_dog/features/account/view/widgets/app_format_date.dart';
import 'package:parki_dog/features/account/view/widgets/default_suffix_icon.dart';
import 'package:parki_dog/features/account/view/widgets/gender_selection_widget.dart';
import 'package:parki_dog/features/account/view/widgets/select_datetime_popup.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/back_appbar.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../data/account_repository.dart';
import '../widgets/add_image_widget.dart';
import '../widgets/custom_input_field.dart';

class EditPersonalInfoScreen extends StatelessWidget {
  EditPersonalInfoScreen({super.key});

  static final _formKey =
      GlobalKey<FormBuilderState>(debugLabel: 'edit_personal_info');

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackAppBar(),
        title: const Text(LocaleKeys.profile_editBasicInfo).tr(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDouble.d24, vertical: AppDouble.d32),
        child: ElevatedButton(
            onPressed: () {
              // if (editBasicInfoCubit.basicInfoGormKey.currentState!
              //     .validate()) {

              // }
              // editBasicInfoCubit.save();
            },
            child: const Text(LocaleKeys.profile_save).tr()),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.symmetric(
              vertical: AppDouble.d16, horizontal: AppDouble.d24),
          children: [
            const SizedBox(height: AppDouble.d32),
            AddImageWidget(
              onTap: () async {
                // editBasicInfoCubit
                //     .pickDogOwnerImage(); // Call the cubit method
              },
              imageAsset: ImageAssets.person,
              uploadedImage: File(''),
            ),
            const SizedBox(height: AppDouble.d24),
            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    hint: LocaleKeys.dogOwner_firstName.tr(),
                    label: LocaleKeys.dogOwner_firstName.tr(),
                    onChanged: (firstName) {
                      // editBasicInfoCubit.updateInfoProcess(
                      //     firstName: firstName);
                    },
                    // controller: TextEditingController(),
                    controller: firstNameController,
                    //  controller:  editBasicInfoCubit.firstNameController,
                    // validator: validateRequiredField,
                  ),
                ),
                const SizedBox(width: AppDouble.d8),
                Expanded(
                  child: CustomInputField(
                    hint: LocaleKeys.dogOwner_lastName.tr(),
                    label: LocaleKeys.dogOwner_lastName.tr(),
                    onChanged: (lastName) {
                      // editBasicInfoCubit.updateInfoProcess(
                      //     lastName: lastName);
                    },
                    controller: lastNameController,
                    // controller: editBasicInfoCubit.lastNameController,
                    // validator: validateRequiredField,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDouble.d24),
            GenderSelectionWidget(
              // genderController: TextEditingController(),
              genderController: genderController,
              // genderController: editBasicInfoCubit.genderController,
              onSelected: (gender) {
                genderController.text = gender.name.tr().capitalizeFirst();
              },
            ),
            const SizedBox(height: AppDouble.d24),
            InkWell(
              onTap: () {
                selectDateTimePopup(context,
                    title: LocaleKeys.dateAndTimePicker_selectDate,
                    onDateTimeChanged: (date) {
                  dateOfBirthController.text = date.appDateStringFormat();
                });
              },
              borderRadius: BorderRadius.circular(AppDouble.d16),
              child: CustomInputField(
                  hint: LocaleKeys.dogOwner_birthDateHint.tr(),
                  label: LocaleKeys.dogOwner_birthDate.tr(),
                  enabled: false,
                  controller: TextEditingController(),
                  // controller: editBasicInfoCubit.birthDateController,
                  // validator: validateRequiredField,
                  suffixIcon: const DefaultSuffixIcon(
                    assetName: ImageAssets.calendar,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final fullName = _formKey.currentState!.fields['Full Name']!.value
          .toString()
          .split(' ');

      final lastName = fullName.removeLast();
      final firstName = fullName.join(' ');

      final phone = _formKey.currentState!.fields['Phone Number']!.value;
      final address = _formKey.currentState!.fields['Home Address']!.value;
      final DateTime dob = DateFormat('dd/MM/yy')
          .parse(_formKey.currentState!.fields['Date of Birth']!.value);
      final gender = _formKey.currentState!.fields['Gender']!.value.first;

      final updatedFields = {
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob,
        'gender': gender,
        'phone': phone,
        'address': address,
      };

      await context
          .read<AccountCubit>()
          .editUserInfo(GetIt.instance.get<UserModel>().id!, updatedFields)
          .then((_) {
        final state = context.read<AccountCubit>().state;

        if (state is UserInfoUpdated) {
          GetIt.instance.registerSingleton<UserModel>(
            GetIt.instance.get<UserModel>().copyWith(
                  firstName: firstName,
                  lastName: lastName,
                  dob: dob,
                  gender: gender,
                  phone: phone,
                  address: address,
                ),
          );
          // context.read<AuthCubit>().accountDataChanged(name);

          Navigator.pop(context);
        }
      });
    }
  }
}
