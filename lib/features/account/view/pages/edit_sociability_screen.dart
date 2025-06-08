import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/validators/form_validators.dart';
import 'package:parki_dog/core/widgets/breed_selector_field.dart';
import 'package:parki_dog/core/widgets/gender_selector.dart';
import 'package:parki_dog/core/widgets/input_field.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/core/widgets/weight_toggle.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/data/unsocial_with_model.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class EditSociabilityScreen extends StatelessWidget {
  EditSociabilityScreen({super.key});

  final UnsocialWithModel? unsocialWith = GetIt.I.get<DogModel>().unsocialWith;
  static final _formKey = GlobalKey<FormBuilderState>(debugLabel: 'edit_sociability');

  final WeightToggle weightToggle = WeightToggle();

  @override
  Widget build(BuildContext context) {
    weightToggle.condition = unsocialWith?.weightCondition ?? '>';
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Sociability'.tr(),
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
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: Hero(
                          tag: 'avatar',
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Avatar(
                              '',
                              radius: 48,
                              hasStatus: false,
                            ),
                          ),
                        ),
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
                      const SizedBox(height: 24),
                      BreedSelectorField(
                        selectionMode: 'multiple'.tr(),
                        initialValue: unsocialWith?.breeds,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        child: Row(
                          children: [
                            Expanded(
                              child: InputField(
                                icon: weightToggle,
                                label: 'Weight'.tr(),
                                text: unsocialWith?.weight,
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
                      GenderSelector(selectionMode: 'multiple'.tr(), initialValue: unsocialWith?.gender),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24),
          child: PushButton(text: 'Save', onPress: () async => await _onSave(context)),
        ),
      );
    });
  }

  Future<void> _onSave(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String breeds = _formKey.currentState!.fields['Breeds']!.value;
      List<String> breedList = breeds.split(', ');

      final weight = _formKey.currentState!.fields['Weight']!.value;
      final genders = _formKey.currentState!.fields['Gender']!.value;

      final unsocialModel = UnsocialWithModel(
        breeds: breedList,
        weight: weight,
        weightCondition: weightToggle.condition,
        gender: genders,
      );

      final updatedFields = {'unsocialWith': unsocialModel.toMap()};

      final dog = GetIt.I.get<DogModel>();

      await context.read<AccountCubit>().editDogInfo(dog.id!, updatedFields).then((_) {
        final state = context.read<AccountCubit>().state;

        if (state is DogInfoUpdated) {
          GetIt.instance.registerSingleton<DogModel>(
            dog.copyWith(
              unsocialWith: unsocialModel,
            ),
          );

          Navigator.pop(context);
        }
      });
    }
  }
}
