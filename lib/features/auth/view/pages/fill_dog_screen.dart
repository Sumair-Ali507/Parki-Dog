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
import 'package:parki_dog/core/widgets/step_progress_bar.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/view/widgets/user_add_photo.dart';

import '../../../home/view/pages/home_screen.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../widgets/dog_add_photo.dart';

class FillDogScreen extends StatefulWidget {
  const FillDogScreen({super.key, required this.password});

  final String password;

  @override
  State<FillDogScreen> createState() => _FillDogScreenState();
}

class _FillDogScreenState extends State<FillDogScreen> {
  static final _formKey = GlobalKey<FormBuilderState>(debugLabel: 'dog_form');
  final int currentStep = 3;
  String? selectedBreed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Information'.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
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
                        child: DogAddPhoto(
                          placeholderAsset: 'assets/images/dog placeholder.png',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: InputField(
                          label: 'Dog Name'.tr(),
                          validator: FormValidators.required(),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _buildBreedDropdown(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: InputField(
                          label: 'Weight (Kg)'.tr(),
                          validator: FormValidators.required(),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _buildSizeDropdown(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is UserUpdated) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen(parks: [])),
                  (Route<dynamic> route) => false);
            }
          },
          child: PushButton(
            text: 'Done'.tr(),
            onPress: () => _onNextPressed(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBreedDropdown() {
    return FormBuilderField<String>(
      name: 'Breed',
      validator: FormValidators.required(),
      builder: (FormFieldState<String> field) {
        return InputDecorator(
          decoration: InputDecoration(
            isDense: true,
            errorMaxLines: 2,
            labelText: 'Breed'.tr(),
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
                'Select Breed'.tr(),
                style: const TextStyle(color: Colors.grey),
              ),
              items: [
                'Labrador',
                'German Shepherd',
                'Golden Retriever',
                'Bulldog',
                'Other'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.tr()),
                );
              }).toList(),
              onChanged: (newValue) {
                field.didChange(newValue);
                setState(() {
                  selectedBreed = newValue;
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSizeDropdown() {
    return FormBuilderField<String>(
      name: 'Size',
      validator: FormValidators.required(),
      builder: (FormFieldState<String> field) {
        return InputDecorator(
          decoration: InputDecoration(
            isDense: true,
            errorMaxLines: 2,
            labelText: 'Size'.tr(),
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
                'Select Size'.tr(),
                style: const TextStyle(color: Colors.grey),
              ),
              items: ['Small', 'Medium', 'Large'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.tr()),
                );
              }).toList(),
              onChanged: (newValue) {
                field.didChange(newValue);
              },
            ),
          ),
        );
      },
    );
  }

  void _onNextPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final dogName = _formKey.currentState!.fields['Dog Name']!.value;
      final breed = _formKey.currentState!.fields['Breed']!.value;
      final weight = _formKey.currentState!.fields['Weight (Kg)']!.value;
      final size = _formKey.currentState!.fields['Size']!.value;

      // Create dog model with photo
      final dog = DogModel(
        photoUrl: StringsManager.dogImage,
        name: dogName,
        breed: breed,
        weight: weight,
        gender: size, // Using size as gender temporarily
      );

      // Save dog data to cubit
      context.read<AuthCubit>().tempDogData = dog;
      // context
      //     .read<AuthCubit>()
      //     .signUp(context.read<AuthCubit>().tempUserModel!, widget.password);
      AuthCubit()
          .signUp(context.read<AuthCubit>().tempUserModel!, widget.password);

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => const HomeScreen(parks: [])),
      //     (Route<dynamic> route) => false);
    }
  }
}
