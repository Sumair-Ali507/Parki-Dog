

// import 'package:flutter/material.dart';

// class OwnerColumn extends StatelessWidget {
//   final Profile? profile;
//   const OwnerColumn({
//     super.key,
//     this.profile,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         OwnerImage(
//           imageAsset: ImageAssets.owner,
//           onTap: () {},
//           ownerName: '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}',
//         ),
//         const SizedBox(height: AppDouble.d24),
//         ProfileContainer(
//             title: LocaleKeys.profile_basicInfo,
//             isEdit: true,
//             onTap: () {
//               context.pushNamed(Routes.editBasicProfileRoute,arguments: profile);
//             },
//             child: Column(
//               children: [
//                 ProfileContainerRow(
//                     text: LocaleKeys.profile_name,
//                     iconAsset: ImageAssets.name,
//                     value:
//                         '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}'),
//                 ProfileContainerRow(
//                     text: LocaleKeys.profile_gender,
//                     iconAsset: ImageAssets.man,
//                     value: LocaleKeys.gender_gMale.tr()),
//                 const ProfileContainerRow(
//                     text: LocaleKeys.profile_birthDate,
//                     iconAsset: ImageAssets.calendarHeart,
//                     value: 'Oct 31, 1999',
//                     isEnd: true),
//               ],
//             )),
//         const SizedBox(height: AppDouble.d24),
//         ProfileContainer(
//             title: LocaleKeys.profile_contactInfo,
//             isEdit: true,
//             onTap: () {
//               context.pushNamed(Routes.editContactProfileRoute,arguments: profile);
//             },
//             child: Column(
//               children: [
//                 ProfileContainerRow(
//                     text: LocaleKeys.profile_phone,
//                     iconAsset: ImageAssets.mobile,
//                     value: profile?.phone ?? ''),
//                 ProfileContainerRow(
//                     text: LocaleKeys.profile_address,
//                     iconAsset: ImageAssets.locationPin,
//                     value: profile?.country ?? '',
//                     isEnd: true),
//               ],
//             )),
//         const SizedBox(height: AppDouble.d24),
//         LogOutButton(onTap: () {
//           logoutDialog(context);
//         })
//       ],
//     );
//   }
// }
