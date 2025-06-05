import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:parki_dog/core/services/location/cubit/location_cubit.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/validators/form_validators.dart';
import 'package:parki_dog/core/widgets/input_field.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/view/widgets/link_button.dart';
import 'package:parki_dog/features/home/cubit/home_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  static final _loginFormKey = GlobalKey<FormBuilderState>(debugLabel: 'login_form');

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _loginFormKey,
      child: Column(
        children: [
          InputField(
            label: 'Email',
            icon: CustomIcons.email,
            validator: FormValidators.email(),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          InputField(
            label: 'Password'.tr(),
            icon: CustomIcons.key,
            obscureText: true,
            validator: FormValidators.password(),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: LinkButton(
                text: 'Forgot Password?'.tr(), onPress: () => Navigator.pushNamed(context, '/auth/forgetPassword')),
          ),
          const SizedBox(height: 36),
          PushButton(
            text: 'Login',
            onPress: () async => await _onLoginPressed(context),
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Future<void> _onLoginPressed(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      final email = _loginFormKey.currentState!.fields['Email']!.value;
      final password = _loginFormKey.currentState!.fields['Password']!.value;
      final auth = context.read<AuthCubit>();
      await auth.signIn(email, password).then((value) async {
        final state = auth.state;
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is SignInSuccess) {
          final home = context.read<HomeCubit>();
          final location = context.read<LocationCubit>();

          await home
              .init(location.location)
              .then((value) => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false));
        }
      });
    }
  }
}
