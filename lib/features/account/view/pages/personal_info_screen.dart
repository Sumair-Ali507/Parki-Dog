import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/account/view/widgets/account_detail_tile.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';
import 'package:parki_dog/features/auth/view/widgets/link_button.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../data/account_repository.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      buildWhen: (previous, current) => current is UserInfoUpdated,
      builder: (context, state) {
        final user = GetIt.instance.get<UserModel>();
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
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset(
                      'assets/images/blob.png',
                      color: AppColors.secondary,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      left: MediaQuery.of(context).size.width * 0.18,
                      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Avatar(
                            GetIt.instance.get<UserModel>().photoUrl,
                            radius: 48,
                            hasStatus: false,
                          ),
                        );
                      }),
                    ),
                    Positioned(
                      bottom: 30,
                      left: MediaQuery.of(context).size.width * 0.5,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text.rich(
                          style: const TextStyle(height: 1),
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${user.firstName!} ',
                                style: const TextStyle(
                                  fontSize: 24,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: user.lastName!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 135,
                      child: GestureDetector(
                        onTap: () async {
                          await context.read<AccountCubit>().pickImage(context: context);
                          await AccountRepository.uploadImage(context: context);
                          await context.read<AuthCubit>().retrieveUserData(GetIt.instance.get<UserModel>().id!);
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.black87,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'General Info'.tr(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          LinkButton(
                            text: 'Edit'.tr(),
                            onPress: () => Navigator.pushNamed(context, '/account/my-info/edit'),
                            color: AppColors.primary,
                            icon: CustomIcons.edit,
                          ),
                        ],
                      ),
                      const Divider(),
                      Column(
                        children: [
                          AccountDetailTile(
                              icon: CustomIcons.user,
                              title: 'Full Name'.tr(),
                              info: '${user.firstName!} ${user.lastName!}'),
                          AccountDetailTile(icon: CustomIcons.gender, title: 'Gender'.tr(), info: user.gender!),
                          AccountDetailTile(
                              icon: CustomIcons.calendarHeart,
                              title: 'Date of Birth',
                              info: DateFormat.yMMMMd().format(user.dob!)),
                          const Divider(),
                          AccountDetailTile(icon: CustomIcons.phone, title: 'Phone Number'.tr(), info: user.phone!),
                          AccountDetailTile(icon: CustomIcons.userPin, title: 'Address'.tr(), info: user.address!),
                          const SizedBox(
                            height: 20,
                          ),
                          PushButton(
                              color: Colors.red,
                              textColor: Colors.white,
                              text: "Delete account".tr(),
                              onPress: () => context.read<AccountCubit>().deleteUSer(context: context, id: user.id!))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }
}
