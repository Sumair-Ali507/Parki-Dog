import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/validators/form_validators.dart';
import 'package:parki_dog/core/widgets/breed_selector_field.dart';
import 'package:parki_dog/core/widgets/gender_selector.dart';
import 'package:parki_dog/core/widgets/input_field.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/core/widgets/weight_toggle.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/data/unsocial_with_model.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class FillUnsocialWithScreen extends StatelessWidget {
  FillUnsocialWithScreen({super.key});

  static final _formKey = GlobalKey<FormBuilderState>(debugLabel: 'dog_unsocial_form');

  final WeightToggle weightDropdown = WeightToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          titleSpacing: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Sociability'.tr(),
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
                  'HelpUsUnderstandWhichBreeds'.tr(),
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
                      const SizedBox(height: 24),
                      BreedSelectorField(
                        selectionMode: 'multiple'.tr(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        child: Row(
                          children: [
                            Expanded(
                              child: InputField(
                                icon: weightDropdown,
                                label: 'Weight'.tr(),
                                validator: FormValidators.weight(),
                                keyboardType: const TextInputType.numberWithOptions(),
                                suffix: const SizedBox(
                                    height: 54,
                                    width: 50,
                                    child: Center(
                                        child: Text(
                                      'Kg',
                                      style: TextStyle(fontSize: 16),
                                    ))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Gender'.tr(),
                            style:
                                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary)),
                      ),
                      const SizedBox(height: 8),
                      GenderSelector(selectionMode: 'multiple'.tr()),
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
              if (state is OnboardSuccess) {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              }

              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: PushButton(text: 'Done'.tr(), onPress: () => _onDonePressed(context)),
          ),
        ),
        extendBody: true,
      );
    });
  }

  Future<void> _onDonePressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<String> breedList = [];
      String breeds = _formKey.currentState!.fields['Breeds']!.value;
      breedList = breeds.split(', ');

      final weight = _formKey.currentState!.fields['Weight']!.value;
      final genders = _formKey.currentState!.fields['Gender']!.value;

      context.read<AuthCubit>().tempDogData!.unsocialWith = UnsocialWithModel(
        breeds: breedList,
        gender: genders,
        weight: weight,
        weightCondition: weightDropdown.condition,
      );

      await context.read<AuthCubit>().onOnboardingComplete();
    }
  }
}
