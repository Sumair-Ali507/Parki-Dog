import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/view/widgets/link_button.dart';
import 'package:parki_dog/features/auth/view/widgets/login_form.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: 'logopure',
                    child: SvgPicture.asset(
                      'assets/images/logoSvg.svg',
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome back!'.tr(),
                    style: const TextStyle(
                        fontSize: 24,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  const LoginForm(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider(endIndent: 16)),
                      Text(
                        'Or continue with'.tr(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Expanded(child: Divider(indent: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocListener<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is UserNotFound) {
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/auth/signup/fill-personal', (route) => false);
                          }

                          if (state is SignInSuccess) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false);
                          }
                        },
                        child: PushButton(
                          text: 'Google',
                          fontSize: 14,
                          textColor: Colors.black,
                          onPress: () async =>
                              await context.read<AuthCubit>().googleSignIn(),
                          icon: CustomIcons.google,
                          height: 40,
                          borderRadius: 8,
                          color: Colors.transparent,
                          fill: false,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      PushButton(
                        text: 'Facebook',
                        fontSize: 14,
                        textColor: Colors.black,
                        onPress: () async =>
                            await context.read<AuthCubit>().facebookSingingIn(),
                        icon: CustomIcons.facebook,
                        height: 40,
                        borderRadius: 8,
                        color: Colors.transparent,
                        fill: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?'.tr(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      LinkButton(
                          text: 'Sign Up'.tr(),
                          onPress: () =>
                              Navigator.pushNamed(context, '/auth/signup')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
