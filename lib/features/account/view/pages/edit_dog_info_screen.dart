import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/validators/form_validators.dart';
import 'package:parki_dog/core/widgets/breed_selector_field.dart';
import 'package:parki_dog/core/widgets/date_selector_field.dart';
import 'package:parki_dog/core/widgets/gender_selector.dart';
import 'package:parki_dog/core/widgets/input_field.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

import '../../../auth/data/user_model.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../data/account_repository.dart';

class EditDogInfoScreen extends StatelessWidget {
  EditDogInfoScreen({super.key});

  static final _formKey = GlobalKey<FormBuilderState>(debugLabel: 'edit_dog_info_form');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'General Info'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: CupertinoButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel'.tr(),
                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: GoogleFonts.poppins().fontFamily),
              )),
          leadingWidth: 100,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  height: constraints.maxWidth * 0.48 + 20,
                  child: Stack(
                    // alignment: Alignment.bottomCenter,
                    children: [
                      Image.asset(
                        'assets/images/blob-2.png',
                        color: AppColors.secondary,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                          return GestureDetector(
                            onTap: () async {
                              // await context.read<AccountCubit>().pickImage(context: context);
                              // await AccountRepository.uploadDogImage(context: context);
                              // await context.read<AuthCubit>().retrieveUserData(GetIt.instance.get<UserModel>().id!);
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Avatar(
                                GetIt.instance.get<DogModel>().photoUrl,
                                radius: 48,
                                hasStatus: false,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: InputField(
                          label: 'Dog Name'.tr(),
                          text: GetIt.instance.get<DogModel>().name,
                          validator: FormValidators.name(),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: BreedSelectorField(initialValue: [GetIt.instance.get<DogModel>().breed!]),
                      ),
                      // const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: DateSelectorField(initialValue: GetIt.instance.get<DogModel>().dob),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: InputField(
                          label: 'Weight (Kg)'.tr(),
                          text: GetIt.instance.get<DogModel>().weight.toString(),
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
                      GenderSelector(initialValue: [GetIt.instance.get<DogModel>().gender!]),
                      // PushButton(text: 'Save', onPress: () {}),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24),
          child: PushButton(text: 'Save'.tr(), onPress: () async => await _onSave(context)),
        ),
      );
    });
  }

  Future<void> _onSave(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final name = _formKey.currentState!.fields['Dog Name']!.value;
      final breed = _formKey.currentState!.fields['Breed']!.value;
      final DateTime dob = DateFormat('dd/MM/yy').parse(_formKey.currentState!.fields['Date of Birth']!.value);
      final weight = _formKey.currentState!.fields['Weight (Kg)']!.value;
      final gender = _formKey.currentState!.fields['Gender']!.value.first;

      final updatedFields = {
        'name': name,
        'breed': breed,
        'dob': dob,
        'weight': weight,
        'gender': gender,
      };

      await context.read<AccountCubit>().editDogInfo(GetIt.instance.get<DogModel>().id!, updatedFields).then((_) {
        final state = context.read<AccountCubit>().state;

        if (state is DogInfoUpdated) {
          GetIt.instance.registerSingleton<DogModel>(
            GetIt.instance.get<DogModel>().copyWith(
                  name: name,
                  breed: breed,
                  dob: dob,
                  weight: weight,
                  gender: gender,
                ),
          );
          context.read<AuthCubit>().accountDataChanged(name);

          Navigator.pop(context);
        }
      });
    }
  }
}
