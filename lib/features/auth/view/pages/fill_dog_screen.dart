import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/resources_manager/strings_manager.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/validators/form_validators.dart';
import 'package:parki_dog/core/widgets/breed_selector_field.dart';
import 'package:parki_dog/core/widgets/date_selector_field.dart';
import 'package:parki_dog/core/widgets/gender_selector.dart';
import 'package:parki_dog/core/widgets/input_field.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/view/widgets/user_add_photo.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../widgets/dog_add_photo.dart';

class FillDogScreen extends StatelessWidget {
  const FillDogScreen({super.key});

  static final _formKey = GlobalKey<FormBuilderState>(debugLabel: 'dog_form');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Dog Information'.tr(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Introduce your dog!'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: DogAddPhoto(
                          placeholderAsset: 'assets/images/dog placeholder.png',
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: InputField(
                          label: 'Dog Name'.tr(),
                          validator: FormValidators.name(),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: BreedSelectorField(),
                      ),
                      // const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: DateSelectorField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: InputField(
                          label: 'Weight (Kg)'.tr(),
                          validator: FormValidators.phone(),
                          keyboardType: const TextInputType.numberWithOptions(),
                        ),
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
          child: PushButton(
            text: 'Next'.tr(),
            onPress: () async => await _onNextPressed(context),
          ),
        ),
        extendBody: true,
      );
    });
  }

  Future<void> _onNextPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final name = _formKey.currentState!.fields['Dog Name']!.value;
      final breed = _formKey.currentState!.fields['Breed']!.value;
      final DateTime dob = DateFormat('dd/MM/yy').parse(_formKey.currentState!.fields['Date of Birth']!.value);
      final weight = _formKey.currentState!.fields['Weight (Kg)']!.value;
      final gender = _formKey.currentState!.fields['Gender']!.value.first;

      final dog = DogModel(
        photoUrl: StringsManager.dogImage,
        name: name,
        breed: breed,
        dob: dob,
        weight: weight,
        gender: gender,
      );

      context.read<AuthCubit>().tempDogData = dog;
      Navigator.pushNamed(context, '/auth/signup/fill-unsocial-with');
    }
  }
}
