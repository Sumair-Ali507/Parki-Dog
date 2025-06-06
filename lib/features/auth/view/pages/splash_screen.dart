import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/animations/zig_zag_animation.dart';
import 'package:parki_dog/core/services/location/cubit/location_cubit.dart';
import 'package:parki_dog/core/services/preferences/preferences_service.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenRouteFunction(
      splash: Stack(
        children: [
          ZigzagAnimation(),
          Center(
            child: Hero(
              tag: 'logopur2',
              child: SvgPicture.asset(
                'assets/images/logo-pure.svg',
              ),
            ),
          ),
        ],
      ),
      splashIconSize: MediaQuery.of(context).size.width * 0.6,
      screenRouteFunction: () async {
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

        return route;
      },
    );
  }
}
