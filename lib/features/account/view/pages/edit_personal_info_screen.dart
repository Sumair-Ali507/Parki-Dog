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
import 'package:parki_dog/core/widgets/date_selector_field.dart';
import 'package:parki_dog/core/widgets/gender_selector.dart';
import 'package:parki_dog/core/widgets/input_field.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

import '../../../auth/cubit/auth_cubit.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../data/account_repository.dart';

class EditPersonalInfoScreen extends StatelessWidget {
  EditPersonalInfoScreen({super.key});

  static final _formKey = GlobalKey<FormBuilderState>(debugLabel: 'edit_personal_info');

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
                              // await AccountRepository.uploadImage(context: context);
                              // await context.read<AuthCubit>().retrieveUserData(GetIt.instance.get<UserModel>().id!);
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Avatar(
                                GetIt.instance.get<UserModel>().photoUrl,
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
                          label: 'Full Name'.tr(),
                          text:
                              '${GetIt.instance.get<UserModel>().firstName!} ${GetIt.instance.get<UserModel>().lastName!}',
                          validator: FormValidators.name(),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      // const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: DateSelectorField(initialValue: GetIt.instance.get<UserModel>().dob),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Gender'.tr(),
                            style:
                                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary)),
                      ),
                      const SizedBox(height: 8),
                      GenderSelector(initialValue: [GetIt.instance.get<UserModel>().gender!]),
                      const SizedBox(height: 36),
                      InputField(
                        label: 'Phone Number'.tr(),
                        text: GetIt.instance.get<UserModel>().phone!,
                        validator: FormValidators.phone(),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),
                      InputField(
                        label: 'Home Address'.tr(),
                        text: GetIt.instance.get<UserModel>().address!,
                        validator: FormValidators.required(),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24),
          child: PushButton(text: 'Save'.tr(), onPress: () async => _onSave(context)),
        ),
      );
    });
  }

  Future<void> _onSave(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final fullName = _formKey.currentState!.fields['Full Name']!.value.toString().split(' ');

      final lastName = fullName.removeLast();
      final firstName = fullName.join(' ');

      final phone = _formKey.currentState!.fields['Phone Number']!.value;
      final address = _formKey.currentState!.fields['Home Address']!.value;
      final DateTime dob = DateFormat('dd/MM/yy').parse(_formKey.currentState!.fields['Date of Birth']!.value);
      final gender = _formKey.currentState!.fields['Gender']!.value.first;

      final updatedFields = {
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob,
        'gender': gender,
        'phone': phone,
        'address': address,
      };

      await context.read<AccountCubit>().editUserInfo(GetIt.instance.get<UserModel>().id!, updatedFields).then((_) {
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
