import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/validators/form_validators.dart';
import 'package:parki_dog/core/widgets/date_selector_field.dart';
import 'package:parki_dog/core/widgets/gender_selector.dart';
import 'package:parki_dog/core/widgets/input_field.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/core/widgets/step_progress_bar.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/view/widgets/user_add_photo.dart';

import '../../../../core/resources_manager/strings_manager.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class FillPersonalScreen extends StatefulWidget {
  const FillPersonalScreen({super.key});

  @override
  State<FillPersonalScreen> createState() => _FillPersonalScreenState();
}

class _FillPersonalScreenState extends State<FillPersonalScreen> {
  static final _formKey =
      GlobalKey<FormBuilderState>(debugLabel: 'personal_form');
  final int currentStep = 2;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Basic Info'.tr()),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    StepProgressBar(
                      currentStep: currentStep,
                      totalSteps: 3,
                      height: 8,
                    ),
                    const SizedBox(height: 24),
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: UserAddPhoto(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: InputField(
                              label: 'Full Name'.tr(),
                              validator: FormValidators.name(),
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _buildGenderDropdown(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: DateSelectorField(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: InputField(
                              label: 'Phone Number'.tr(),
                              validator: FormValidators.phone(),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: InputField(
                              label: 'Home Address'.tr(),
                              validator: FormValidators.required(),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is UserUpdated) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/auth/signup/fill-dog', (Route<dynamic> route) => false);
              }
            },
            child: PushButton(
                text: 'Next'.tr(),
                onPress: () async => await _onNextPressed(context)),
          ),
        ),
        extendBody: true,
      );
    });
  }

  Widget _buildGenderDropdown() {
    return FormBuilderField<String>(
      name: 'Gender',
      validator: FormValidators.required(),
      builder: (FormFieldState<String> field) {
        return InputDecorator(
          decoration: InputDecoration(
            isDense: true,
            errorMaxLines: 2,
            labelText: 'Gender'.tr(),
            labelStyle: const TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            errorText: field.errorText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: field.value,
              isDense: true,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
              hint: Text(
                'Select Gender'.tr(),
                style: const TextStyle(color: Colors.grey),
              ),
              items: ['Male', 'Female', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.tr()),
                );
              }).toList(),
              onChanged: (newValue) {
                field.didChange(newValue);
                setState(() {
                  selectedGender = newValue;
                });
              },
            ),
          ),
        );
      },
    );
  }

  String? photoUrl() {
    if (StringsManager.socialProfilePicture != null) {
      return StringsManager.socialProfilePicture!;
    } else if (StringsManager.userProfileImage != null) {
      return StringsManager.userProfileImage!;
    } else {
      return null;
    }
  }

  Future<void> _onNextPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final phone = _formKey.currentState!.fields['Phone Number']!.value;
      final address = _formKey.currentState!.fields['Home Address']!.value;
      final dob = _formKey.currentState!.fields['Date of Birth']!.value;
      // final DateTime dob = DateFormat('dd/MM/yy')
      //     .parse(_formKey.currentState!.fields['Date of Birth']!.value);
      final gender = _formKey.currentState!.fields['Gender']!.value;

      context.read<AuthCubit>().tempUserModel =
          context.read<AuthCubit>().tempUserModel?.copyWith(
                photoUrl: photoUrl(),
                phone: phone,
                address: address,
                dob: dob,
                gender: gender,
              );

      Navigator.of(context).pushNamed('/auth/signup/fill-dog');
    }
  }
}
