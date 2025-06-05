import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parki_dog/core/navigation/cubit/navigation_cubit.dart';
import 'package:parki_dog/core/navigation/view/pages/skeleton.dart';
import 'package:parki_dog/core/widgets/breed_selector.dart';
import 'package:parki_dog/core/widgets/date_selector.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/account/view/pages/account_screen.dart';
import 'package:parki_dog/features/account/view/pages/dog_info_screen.dart';
import 'package:parki_dog/features/account/view/pages/edit_dog_info_screen.dart';
import 'package:parki_dog/features/account/view/pages/edit_personal_info_screen.dart';
import 'package:parki_dog/features/account/view/pages/edit_sociability_screen.dart';
import 'package:parki_dog/features/account/view/pages/friends_screen.dart';
import 'package:parki_dog/features/account/view/pages/personal_info_screen.dart';
import 'package:parki_dog/features/auth/view/pages/fill_user_type_screen.dart';
import 'package:parki_dog/features/auth/view/pages/terms_view.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/view/pages/fill_dog_screen.dart';
import 'package:parki_dog/features/auth/view/pages/fill_personal_screen.dart';
import 'package:parki_dog/features/auth/view/pages/fill_unsocial_with_screen.dart';
import 'package:parki_dog/features/auth/view/pages/login_screen.dart';
import 'package:parki_dog/features/auth/view/pages/sign_up_screen.dart';
import 'package:parki_dog/features/auth/view/pages/splash_screen.dart';
import 'package:parki_dog/features/home/view/pages/home_screen.dart';
import 'package:parki_dog/features/home/view/widgets/view_all_dogs.dart';
import 'package:parki_dog/features/lang/lang_cubit.dart';
import 'package:parki_dog/features/lang/lang_state.dart';
import 'package:parki_dog/features/map/cubit/map_cubit.dart';
import 'package:parki_dog/features/map/view/pages/map_screen.dart';

import '../../features/auth/view/pages/forget_password.dart';

class AppRouter {
  static const appScreens = [
    HomeScreen(
      parks: [],
    ),
    MapScreen()
  ];
  final NavigationCubit _navigationCubit = NavigationCubit();
  final AccountCubit _accountCubit = AccountCubit();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // return MaterialPageRoute(builder: (_) => const FillUserTypeScreen());
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/auth/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/auth/forgetPassword':
        return MaterialPageRoute(builder: (_) => const ForgetPassword());

      case '/auth/signup':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case '/auth/terms':
        return MaterialPageRoute(builder: (_) => const TermsView());

      case '/auth/signup/fill-personal':
        return MaterialPageRoute(builder: (_) => const FillPersonalScreen());

      case '/auth/signup/fill-dog':
        return MaterialPageRoute(builder: (_) => const FillDogScreen());

      case '/auth/signup/fill-unsocial-with':
        return MaterialPageRoute(builder: (_) => FillUnsocialWithScreen());

      case '/home':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(providers: [
            BlocProvider.value(
              value: _navigationCubit,
            ),
            BlocProvider(
              create: (context) => MapCubit(_navigationCubit),
            ),
          ], child: const Skeleton()),
        );

      case '/account':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _accountCubit,
                  child: const AccountScreen(),
                ));

      case '/account/my-dog-info':
        return PageTransition(
            child: BlocProvider.value(
              value: _accountCubit,
              child: const DogInfoScreen(),
            ),
            type: PageTransitionType.fade);

      case '/account/my-dog-info/edit-general':
        return PageTransition(
            child: BlocProvider.value(
              value: _accountCubit,
              child: EditDogInfoScreen(),
            ),
            type: PageTransitionType.fade);

      case '/account/my-dog-info/edit-sociability':
        return PageTransition(
            child: BlocProvider.value(
              value: _accountCubit,
              child: EditSociabilityScreen(),
            ),
            type: PageTransitionType.fade);

      case '/account/my-info':
        return PageTransition(
            child: BlocProvider.value(
              value: _accountCubit,
              child: const PersonalInfoScreen(),
            ),
            type: PageTransitionType.fade);

      case '/account/my-info/edit':
        return PageTransition(
            child: BlocProvider.value(
              value: _accountCubit,
              child: EditPersonalInfoScreen(),
            ),
            type: PageTransitionType.fade);

      case '/account/friends':
        return PageTransition(
            child: BlocProvider.value(
              value: _accountCubit,
              child: const FriendsScreen(),
            ),
            type: PageTransitionType.fade);

      // case '/home':
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider<HomeCubit>(
      //       create: (context) => HomeCubit(),
      //       child: const HomeScreen(),
      //     ),
      //   );

      // case '/map':
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider<MapCubit>(
      //       create: (context) => MapCubit(),
      //       child: const MapScreen(),
      //     ),
      //   );

      case '/home/current-checkin/dogs':
        final dogs = settings.arguments as List<DogModel>;
        return PageTransition(
            child: ViewAllDogs(dogs),
            type: PageTransitionType.rightToLeftWithFade,
            settings: settings);

      case '/breed-selector':
        return PageTransition(
            child: const BreedSelector(),
            type: PageTransitionType.bottomToTop,
            settings: settings);

      case '/date-selector':
        return PageTransition(
            child: const DateSelector(), type: PageTransitionType.bottomToTop);

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
