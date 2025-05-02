import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/view/widgets/sign_up_form.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Cute Dog.png',
                      width: MediaQuery.of(context).size.width * 0.27,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Sign Up'.tr(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SignUpForm(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(child: Divider(endIndent: 16)),
                        Text(
                          'Or sign up with'.tr(),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Expanded(child: Divider(indent: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    PushButton(
                      text: 'Google',
                      fontSize: 14,
                      textColor: Colors.black,
                      onPress: () async => await context.read<AuthCubit>().googleSignIn(),
                      icon: CustomIcons.google,
                      height: 40,
                      borderRadius: 8,
                      color: Colors.transparent,
                      fill: false,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    PushButton(
                      text: 'Facebook',
                      fontSize: 14,
                      textColor: Colors.black,
                      onPress: () async => await context.read<AuthCubit>().facebookSingingIn(),
                      icon: CustomIcons.facebook,
                      height: 40,
                      borderRadius: 8,
                      color: Colors.transparent,
                      fill: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
