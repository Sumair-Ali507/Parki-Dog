import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/shared_widgets/svg_icon.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/values_manager.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/account/cubit/toggle_dog_owner_cubit.dart';
import 'package:parki_dog/features/account/view/widgets/account_detail_tile.dart';
import 'package:parki_dog/features/account/view/widgets/log_out_button.dart';
import 'package:parki_dog/features/account/view/widgets/logout_dialog.dart';
import 'package:parki_dog/features/account/view/widgets/owner_dog_toggle.dart';
import 'package:parki_dog/features/account/view/widgets/profile_container.dart';
import 'package:parki_dog/features/account/view/widgets/profile_container_row.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';
import 'package:parki_dog/features/auth/view/widgets/link_button.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/widgets/back_appbar.dart' show BackAppBar;
import '../../../../generated/locale_keys.g.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../data/account_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/shared_widgets/svg_icon.dart';
import 'package:parki_dog/core/utils/assets_manager.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/text_styles.dart';
import 'package:parki_dog/core/utils/values_manager.dart';
import 'package:parki_dog/generated/locale_keys.g.dart';
import 'package:intl/intl.dart';

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
              leading: const BackAppBar(),
              title: const Text(LocaleKeys.profile_profile).tr(),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const SvgIcon(
                        color: ColorsManager.grey700,
                        assetName: ImageAssets.moreOutlined))
              ],
            ),
            body: BlocProvider(
              create: (context) => OwnerDogCubit(),
              child: BlocBuilder<OwnerDogCubit, OwnerDogEnum>(
                builder: (ownerDogContext, ownerDogState) {
                  OwnerDogCubit ownerDogCubit =
                      ownerDogContext.read<OwnerDogCubit>();
                  return ListView(
                    padding: const EdgeInsets.all(AppDouble.d16),
                    children: [
                      OwnerDogToggle(ownerDogCubit: ownerDogCubit),
                      const SizedBox(height: AppDouble.d24),
                      if (ownerDogState == OwnerDogEnum.owner)
                        Column(
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  radius: AppDouble.d40,
                                  onTap: () {},
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      CircleAvatar(
                                        radius: AppDouble.d40,
                                        backgroundImage: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBvqzyx_zoi6q2c0Gd1XnE7wysD9PGOLe3-A&s',
                                        ) as ImageProvider,
                                      ),
                                      const CircleAvatar(
                                        radius: AppDouble.d10,
                                        backgroundColor:
                                            ColorsManager.primary100,
                                        child: SvgIcon(
                                            color: ColorsManager.primaryColor,
                                            assetName: ImageAssets.camera),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppDouble.d8),
                                Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: TextStyles.font16Grey600SemiBold(),
                                ),
                                const SizedBox(height: AppDouble.d4),
                                Text(
                                  LocaleKeys.profile_dogOwner,
                                  style: TextStyles.font12Grey400Regular(),
                                ).tr(),
                              ],
                            ),
                            const SizedBox(height: AppDouble.d24),
                            ProfileContainer(
                                title: LocaleKeys.profile_basicInfo,
                                isEdit: true,
                                onTap: () {
                                  // context.pushNamed(Routes.editBasicProfileRoute,arguments: profile);
                                  Navigator.pushNamed(
                                      context, '/account/my-info/edit');
                                },
                                child: Column(
                                  children: [
                                    ProfileContainerRow(
                                        text: LocaleKeys.profile_name,
                                        iconAsset: ImageAssets.name,
                                        value:
                                            '${user.firstName ?? ''} ${user.firstName ?? ''}'),
                                    ProfileContainerRow(
                                        text: LocaleKeys.profile_gender,
                                        iconAsset: ImageAssets.man,
                                        value: user.gender.toString()),
                                    ProfileContainerRow(
                                        text: LocaleKeys.profile_birthDate,
                                        iconAsset: ImageAssets.calendarHeart,
                                        value: DateFormat('MMM dd, yyyy')
                                            .format(user.dob!),
                                        isEnd: true),
                                  ],
                                )),
                            const SizedBox(height: AppDouble.d24),
                            ProfileContainer(
                                title: LocaleKeys.profile_contactInfo,
                                isEdit: true,
                                onTap: () {
                                  // context.pushNamed(Routes.editContactProfileRoute,arguments: profile);
                                },
                                child: Column(
                                  children: [
                                    ProfileContainerRow(
                                        text: LocaleKeys.profile_phone,
                                        iconAsset: ImageAssets.mobile,
                                        value: user.phone ?? ''),
                                    ProfileContainerRow(
                                        text: LocaleKeys.profile_address,
                                        iconAsset: ImageAssets.locationPin,
                                        value: user.address ?? '',
                                        isEnd: true),
                                  ],
                                )),
                            const SizedBox(height: AppDouble.d24),
                            LogOutButton(onTap: () {
                              logoutDialog(context);
                            }),
                            // ],
                          ],
                        ),
                      if (ownerDogState == OwnerDogEnum.dog)
                        Column(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                radius: AppDouble.d40,
                                onTap: () {},
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    CircleAvatar(
                                      radius: AppDouble.d40,
                                      backgroundImage: NetworkImage(GetIt
                                                  .instance
                                                  .get<DogModel>()
                                                  .photoUrl ??
                                              'https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_640.jpg')
                                          as ImageProvider,
                                    ),
                                    const CircleAvatar(
                                      radius: AppDouble.d10,
                                      backgroundColor: ColorsManager.primary100,
                                      child: SvgIcon(
                                          color: ColorsManager.primaryColor,
                                          assetName: ImageAssets.camera),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppDouble.d8),
                              Text(
                                GetIt.instance.get<DogModel>().name ?? '',
                                style: TextStyles.font16Grey600SemiBold(),
                              ),
                              const SizedBox(height: AppDouble.d4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      GetIt.instance.get<DogModel>().breed ??
                                          '',
                                      style: TextStyles.font12Grey400Regular(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: AppInt.i1,
                                    ),
                                  ),
                                  const SizedBox(width: AppDouble.d4),
                                  SvgIcon(
                                      color: ColorsManager.secondaryColor,
                                      assetName: GetIt.instance
                                                  .get<DogModel>()
                                                  .gender ==
                                              'male'
                                          ? ImageAssets.man
                                          : ImageAssets.woman),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDouble.d24),
                          ProfileContainer(
                              title: LocaleKeys.profile_dogInfo,
                              isEdit: true,
                              onTap: () {
                                // context.pushNamed(Routes.updateDogRoute,arguments: profile);
                              },
                              child: Column(
                                children: [
                                  ProfileContainerRow(
                                      text: LocaleKeys.profile_name,
                                      iconAsset: ImageAssets.name,
                                      value:
                                          GetIt.instance.get<DogModel>().name ??
                                              ''),
                                  ProfileContainerRow(
                                      text: LocaleKeys.profile_breed,
                                      iconAsset: ImageAssets.petOutlined,
                                      value: GetIt.instance
                                              .get<DogModel>()
                                              .breed ??
                                          ''),
                                  ProfileContainerRow(
                                      text: LocaleKeys.profile_gender,
                                      iconAsset: ImageAssets.man,
                                      value: GetIt.instance
                                              .get<DogModel>()
                                              .gender ??
                                          'male'),
                                  ProfileContainerRow(
                                      text: LocaleKeys.profile_age,
                                      iconAsset: ImageAssets.calendarHeart,
                                      value:
                                          '${GetIt.instance.get<DogModel>().dob ?? ''}'),
                                  ProfileContainerRow(
                                    text: LocaleKeys.profile_weight,
                                    iconAsset: ImageAssets.weight,
                                    value:
                                        '${GetIt.instance.get<DogModel>().weight ?? ''}',
                                  ),
                                  ProfileContainerRow(
                                      text: LocaleKeys.profile_chipNumber,
                                      iconAsset: ImageAssets.chip,
                                      value:
                                          '${GetIt.instance.get<DogModel>().userId ?? ''}',
                                      isEnd: true),
                                ],
                              )),
                          const SizedBox(height: AppDouble.d24),
                          ProfileContainer(
                              title: 'Unsocialble With',
                              isEdit: true,
                              child: Column(
                                children: [
                                  ProfileContainerRow(
                                      text: LocaleKeys.profile_breeds,
                                      iconAsset: ImageAssets.animalLeg,
                                      value: GetIt.instance
                                              .get<DogModel>()
                                              .unsocialWith!
                                              .breeds
                                              .first ??
                                          ''),
                                  ProfileContainerRow(
                                      text: LocaleKeys.profile_gender,
                                      iconAsset: ImageAssets.man,
                                      value: GetIt.instance
                                              .get<DogModel>()
                                              .unsocialWith!
                                              .gender
                                              .first ??
                                          ''),
                                  ProfileContainerRow(
                                    text: LocaleKeys.profile_weightKg,
                                    iconAsset: ImageAssets.weight,
                                    value:
                                        '${GetIt.instance.get<DogModel>().unsocialWith!.weightCondition} ${GetIt.instance.get<DogModel>().unsocialWith!.weight}',
                                    isEnd: true,
                                  ),
                                ],
                              )),
                          // ProfileContainer(
                          //     title: LocaleKeys.profile_trainings,
                          //     isEdit: false,
                          //     onTap: () {},
                          //     child: const Column(
                          //       children: [],
                          //     )),
                          // const SizedBox(height: AppDouble.d24),
                          // ProfileContainer(
                          //     title: LocaleKeys.profile_vaccination,
                          //     isEdit: false,
                          //     onTap: () {},
                          //     child: const Column(
                          //       children: [],
                          //     )),
                          // const SizedBox(height: AppDouble.d24),
                        ]),
                    ],
                  );
                },
              ),
            ),
          );

          // Scaffold(
          //   appBar: AppBar(
          //     automaticallyImplyLeading: true,
          //     leading: IconButton(
          //       icon: const Icon(Icons.arrow_back_ios),
          //       onPressed: () => Navigator.pop(context),
          //     ),
          //     backgroundColor: Colors.transparent,
          //     elevation: 0,
          //   ),
          //   extendBodyBehindAppBar: true,
          //   body: Column(
          //     children: [
          //       Stack(
          //         alignment: Alignment.bottomCenter,
          //         children: [
          //           Image.asset(
          //             'assets/images/blob.png',
          //             color: AppColors.secondary,
          //             fit: BoxFit.cover,
          //           ),
          //           Positioned(
          //             bottom: 10,
          //             left: MediaQuery.of(context).size.width * 0.18,
          //             child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          //               return CircleAvatar(
          //                 radius: 50,
          //                 backgroundColor: Colors.white,
          //                 child: Avatar(
          //                   GetIt.instance.get<UserModel>().photoUrl,
          //                   radius: 48,
          //                   hasStatus: false,
          //                 ),
          //               );
          //             }),
          //           ),
          //           Positioned(
          //             bottom: 30,
          //             left: MediaQuery.of(context).size.width * 0.5,
          //             child: SizedBox(
          //               width: MediaQuery.of(context).size.width * 0.5,
          //               child: Text.rich(
          //                 style: const TextStyle(height: 1),
          //                 TextSpan(
          //                   children: [
          //                     TextSpan(
          //                       text: '${user.firstName!} ',
          //                       style: const TextStyle(
          //                         fontSize: 24,
          //                         // fontWeight: FontWeight.w600,
          //                       ),
          //                     ),
          //                     TextSpan(
          //                       text: user.lastName!,
          //                       style: const TextStyle(
          //                         fontSize: 24,
          //                         fontWeight: FontWeight.w600,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Positioned(
          //             bottom: 10,
          //             left: 135,
          //             child: GestureDetector(
          //               onTap: () async {
          //                 await context.read<AccountCubit>().pickImage(context: context);
          //                 await AccountRepository.uploadImage(context: context);
          //                 await context.read<AuthCubit>().retrieveUserData(GetIt.instance.get<UserModel>().id!);
          //               },
          //               child: CircleAvatar(
          //                 radius: 15,
          //                 backgroundColor: Colors.black87,
          //                 child: Icon(
          //                   Icons.camera_alt,
          //                   color: Colors.grey[300],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 24),
          //       Padding(
          //         padding: const EdgeInsets.all(24),
          //         child: Column(
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   'General Info'.tr(),
          //                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //                 ),
          //                 LinkButton(
          //                   text: 'Edit'.tr(),
          //                   onPress: () => Navigator.pushNamed(context, '/account/my-info/edit'),
          //                   color: AppColors.primary,
          //                   icon: CustomIcons.edit,
          //                 ),
          //               ],
          //             ),
          //             const Divider(),
          //             Column(
          //               children: [
          //                 AccountDetailTile(
          //                     icon: CustomIcons.user,
          //                     title: 'Full Name'.tr(),
          //                     info: '${user.firstName!} ${user.lastName!}'),
          //                 AccountDetailTile(icon: CustomIcons.gender, title: 'Gender'.tr(), info: user.gender!),
          //                 AccountDetailTile(
          //                     icon: CustomIcons.calendarHeart,
          //                     title: 'Date of Birth',
          //                     info: DateFormat.yMMMMd().format(user.dob!)),
          //                 const Divider(),
          //                 AccountDetailTile(icon: CustomIcons.phone, title: 'Phone Number'.tr(), info: user.phone!),
          //                 AccountDetailTile(icon: CustomIcons.userPin, title: 'Address'.tr(), info: user.address!),
          //                 const SizedBox(
          //                   height: 20,
          //                 ),
          //                 PushButton(
          //                     color: Colors.red,
          //                     textColor: Colors.white,
          //                     text: "Delete account".tr(),
          //                     onPress: () => context.read<AccountCubit>().deleteUSer(context: context, id: user.id!))
          //               ],
          //             )
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // );
        });
      },
    );
  }
}
