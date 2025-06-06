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
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/view/widgets/user_add_photo.dart';

import '../../../../core/resources_manager/strings_manager.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class FillPersonalScreen extends StatelessWidget {
  const FillPersonalScreen({super.key});

  static final _formKey = GlobalKey<FormBuilderState>(debugLabel: 'personal_form');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const SizedBox.shrink(),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information'.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Let us know you!'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ],
            )),
        body: SingleChildScrollView(
          child: Center(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FormBuilder(
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
                      // const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: DateSelectorField(),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Gender'.tr(),
                            style:
                                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary)),
                      ),
                      const SizedBox(height: 8),
                      const GenderSelector(),
                    ],
                  ),
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
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/auth/signup/fill-dog', (Route<dynamic> route) => false);
              }
            },
            child: PushButton(text: 'Next'.tr(), onPress: () async => await _onNextPressed(context)),
          ),
        ),
        extendBody: true,
      );
    });
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
      final DateTime dob = DateFormat('dd/MM/yy').parse(_formKey.currentState!.fields['Date of Birth']!.value);
      final gender = _formKey.currentState!.fields['Gender']!.value.first;

      context.read<AuthCubit>().tempUserModel = context.read<AuthCubit>().tempUserModel!.copyWith(
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
