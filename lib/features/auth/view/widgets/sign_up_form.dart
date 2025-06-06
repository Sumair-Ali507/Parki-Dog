import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/validators/form_validators.dart';
import 'package:parki_dog/core/widgets/input_field.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});
  static final _formKey = GlobalKey<FormBuilderState>(debugLabel: 'signup_form');
  @override
  Widget build(BuildContext context) {
    String? password;
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InputField(
                  label: 'First Name'.tr(),
                  validator: FormValidators.name(),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  label: 'Last Name'.tr(),
                  validator: FormValidators.name(),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          InputField(
            label: 'Email',
            icon: CustomIcons.email,
            validator: FormValidators.email(),
          ),
          const SizedBox(height: 24),
          InputField(
            label: 'Password'.tr(),
            onChanged: (p0) => password = p0,
            icon: CustomIcons.key,
            obscureText: true,
            validator: FormValidators.password(),
          ),
          const SizedBox(height: 24),
          InputField(
            label: 'Confirm Password'.tr(),
            icon: CustomIcons.key,
            obscureText: true,
            validator: (val) {
              if (val != password) {
                return 'Passwords do not match'.tr();
              }

              return null;
            },
          ),
          const SizedBox(height: 48),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                Navigator.pushNamedAndRemoveUntil(context, '/auth/signup/fill-personal', (route) => false);
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
            child: PushButton(
              text: 'Sign up'.tr(),
              onPress: () async => await _onSignUpPressed(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text("By signing up you agree on the".tr(), style: const TextStyle(fontSize: 12)),
                TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/auth/terms'),
                    child: Text(
                      "Terms and condtions".tr(),
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onSignUpPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final email = _formKey.currentState!.fields['Email']!.value;
      final password = _formKey.currentState!.fields['Password']!.value;
      final firstName = _formKey.currentState!.fields['First Name']!.value;
      final lastName = _formKey.currentState!.fields['Last Name']!.value;

      final UserModel user = UserModel(
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      await context.read<AuthCubit>().signUp(user, password);
    }
  }
}
