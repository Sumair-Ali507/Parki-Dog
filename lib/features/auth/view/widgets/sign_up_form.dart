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
import 'package:parki_dog/features/auth/view/pages/fill_user_type_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  static final _formKey =
      GlobalKey<FormBuilderState>(debugLabel: 'signup_form');
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _password;
  String? _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              InputField(
                label: 'Email',
                icon: CustomIcons.email,
                validator: FormValidators.email(),
              ),
              const SizedBox(height: 24),
              InputField(
                label: 'Password'.tr(),
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                icon: CustomIcons.key,
                obscureText: _obscurePassword,
                validator: FormValidators.password(),
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              InputField(
                label: 'Confirm Password'.tr(),
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
                icon: CustomIcons.key,
                obscureText: _obscureConfirmPassword,
                validator: (val) {
                  if (val != _password) {
                    return 'Passwords do not match'.tr();
                  }
                  return null;
                },
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_confirmPassword != null &&
                        _confirmPassword == _password)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/auth/signup/fill-personal', (route) => false);
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
              text: 'Get Started 🚀'.tr(),
              onPress: () async => await _onSignUpPressed(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSignUpPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FillUserTypeScreen()));
      // _formKey.currentState!.save();

      // final email = _formKey.currentState!.fields['Email']!.value;
      // final password = _formKey.currentState!.fields['Password']!.value;
      // final firstName = _formKey.currentState!.fields['First Name']!.value;
      // final lastName = _formKey.currentState!.fields['Last Name']!.value;

      // final UserModel user = UserModel(
      //   email: email,
      //   firstName: firstName,
      //   lastName: lastName,
      // );

      // await context.read<AuthCubit>().signUp(user, password);
    }
  }
}
