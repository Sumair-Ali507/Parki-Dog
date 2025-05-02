import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../core/resources_manager/strings_manager.dart';
import '../../../../core/theme/icons/custom_icons.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../../core/widgets/push_button.dart';
import '../../cubit/auth_cubit.dart';

class ResetForm extends StatelessWidget {
  const ResetForm({
    super.key,
  });

  static final _resetPasswordKey = GlobalKey<FormBuilderState>(debugLabel: 'resetPassword_form');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilder(
          key: _resetPasswordKey,
          child: InputField(
            label: 'Email',
            icon: CustomIcons.email,
            validator: FormValidators.email(),
          ),
        ),
        const SizedBox(height: 24),
        PushButton(
          text: 'Reset Password'.tr(),
          onPress: () async {
            if (_resetPasswordKey.currentState!.validate()) {
              _resetPasswordKey.currentState!.save();
              context
                  .read<AuthCubit>()
                  .forgotPassword(context: context, email: _resetPasswordKey.currentState!.fields['Email']!.value);
              _resetPasswordKey.currentState!.dispose();
            }
          },
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
