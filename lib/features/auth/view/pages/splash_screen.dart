import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as getIt;
import 'package:parki_dog/core/services/location/cubit/location_cubit.dart';
import 'package:parki_dog/core/services/preferences/preferences_service.dart';

import 'package:parki_dog/core/utils/assets_manager.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/text_styles.dart';
import 'package:parki_dog/core/utils/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';

import '../../../../core/animations/zig_zag_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    // Retrieve token from AppPreferences

    // Delay for the splash screen animation
    await Future.delayed(const Duration(seconds: AppInt.i4));

    var route = '/auth/login';

    final location = context.read<LocationCubit>();
    var auth = context.read<AuthCubit>();

    await location.getLocation();

    await auth.isSignedIn();

    await PreferencesService.init();

    GetIt.I.allowReassignment = true;

    // if (auth.state is UserNotFound) route = '/auth/signup/fill-personal';

    if (auth.state is SignInSuccess) {
      // await home.init(location.location);
      route = '/home';
    }

    // print(auth.state);
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: Stack(
        children: [
          const ZigzagAnimation(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(ImageAssets.logoSvg),
                const SizedBox(height: AppDouble.d24),
                Text(
                  'Loading...',
                  style: TextStyles.font16Primary600SemiBold(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
