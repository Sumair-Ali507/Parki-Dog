import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/services/hive/hive.dart';
import 'package:parki_dog/core/services/preferences/preferences_service.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/features/account/view/pages/setting_screen.dart';
import 'package:parki_dog/features/account/view/widgets/account_tile.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';
import '../../../auth/data/user_model.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../cubit/account_cubit.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * (202 / 397) + 15,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: MediaQuery.of(context).size.width),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, double value, child) {
                        return Image.asset(
                          'assets/images/blob.png',
                          width: value,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: MediaQuery.of(context).size.width * 0.5,
                    child: const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: MediaQuery.of(context).size.width * 0.16,
                    child: GestureDetector(
                      onTap: () {
                        //context.read<AccountCubit>().enlargeImage();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Avatar(
                              GetIt.instance.get<UserModel>().photoUrl,
                              radius: 150,
                              hasStatus: false,
                            ); // Custom dialog widget with Hero animation
                          },
                        );
                      },
                      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                        return BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
                          return CircleAvatar(
                              radius: context.read<AccountCubit>().sizeImage,
                              backgroundColor: Colors.white,
                              child: Avatar(
                                GetIt.instance.get<UserModel>().photoUrl,
                                radius: 90,
                                hasStatus: false,
                              ));
                        });
                      }),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: MediaQuery.of(context).size.width * 0.30,
                    child: GestureDetector(
                      onTap: () {
                        //context.read<AccountCubit>().enlargeImageDog();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Avatar(
                              GetIt.instance.get<DogModel>().photoUrl,
                              radius: 150,
                              hasStatus: false,
                            ); // Custom dialog widget with Hero animation
                          },
                        );
                      },
                      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                        return BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
                          return context.read<AccountCubit>().state == HideImage()
                              ? const SizedBox()
                              : CircleAvatar(
                                  radius: context.read<AccountCubit>().sizeImageDog,
                                  backgroundColor: Colors.white,
                                  child: Avatar(
                                    GetIt.instance.get<DogModel>().photoUrl,
                                    radius: 70,
                                    hasStatus: false,
                                  ));
                        });
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                AccountTile(
                    icon: CustomIcons.paw,
                    title: 'My dog info'.tr(),
                    onTap: () => Navigator.pushNamed(context, '/account/my-dog-info')),
                AccountTile(
                    icon: CustomIcons.profile,
                    title: 'My info'.tr(),
                    onTap: () => Navigator.pushNamed(context, '/account/my-info')),
                AccountTile(
                    icon: CustomIcons.bulldogSvg,
                    title: 'Friends'.tr(),
                    onTap: () => Navigator.pushNamed(context, '/account/friends')),
                AccountTile(
                    icon: CustomIcons.settings,
                    title: 'Settings'.tr(),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingScreen(),
                      ));
                    }),
                AccountTile(
                    icon: CustomIcons.terms,
                    title: 'Terms and conditions'.tr(),
                    onTap: () => Navigator.pushNamed(context, '/auth/terms')),
                const Divider(height: 24, indent: 24, endIndent: 24),
                AccountTile(
                    icon: CustomIcons.logout,
                    title: 'Logout'.tr(),
                    onTap: () {
                      context.read<AuthCubit>().signOut();
                      PreferencesService.clearStorage();
                      HiveStorageService.deleteKey(key: 'userToken');
                      Navigator.pushNamedAndRemoveUntil(context, '/auth/login', (route) => false);
                    }),
              ],
            )
          ],
        ),
      );
    });
  }
}
