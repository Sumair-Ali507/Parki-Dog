import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final List<Items> items = [
    Items(
        name: 'Friends', icon: 'assets/images/icons/friends.svg', route: ''),
    Items(
        name: 'My Orders',
        icon: 'assets/images/icons/myOrders.svg',
        route: ''),
    Items(
        name: 'Sign-in & Security',
        icon: 'assets/images/icons/signInAndSecurity.svg',
        route: '/auth/terms'),
    Items(
        name: 'Terms & Conditions',
        icon: 'assets/images/icons/termsAndConditions.svg',
        route: ''),
    Items(
        name: 'App Language',
        icon: 'assets/images/icons/globe.svg',
        route: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 56,
              title: Text('Menu'),
            ),
            body: Container(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    width: 1.sw,
                    height: 80.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: Color(0xFFF3F4F6)),
                    child: SizedBox(
                      width: 80.w,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                clipBehavior: Clip.hardEdge,
                                width: 48.w,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-60IrBVsilxOXQqWSdZUN5nJjlhvdTUVqOQ&s',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 20,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  width: 32.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2)),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://cdn.pixabay.com/photo/2015/11/17/13/13/puppy-1047521_1280.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ahmed Nafee',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Dog: Labrador Retriver',
                                    style: TextStyle(
                                        color: Color(0xFF808086),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  SvgPicture.asset('assets/new-images/man.svg')
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  ...List.generate(items.length, (index) {
                    return MenuItemContainer(
                      route: items[index].route,
                      icon: items[index].icon,
                      itemName: items[index].name,
                    );
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MenuItemContainer extends StatelessWidget {
  const MenuItemContainer({
    super.key,
    required this.icon,
    required this.itemName,
    required this.route,
  });

  final String route;
  final String icon, itemName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.sp),
        width: 1.sw,
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Color(0xFFF3F4F6),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            SizedBox(
              width: 8.w,
            ),
            Text(itemName),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF808086),
            )
          ],
        ),
      ),
    );
  }
}

class Items {
  Items( {
    required this.name,
    required this.icon,
    required this.route,
  });
  final String name, icon;
  final String  route;
}

// Column(
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.width * (202 / 397) + 15,
//               child: Stack(
//                 alignment: Alignment.bottomCenter,
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: TweenAnimationBuilder(
//                       tween: Tween<double>(
//                           begin: 0, end: MediaQuery.of(context).size.width),
//                       duration: const Duration(milliseconds: 500),
//                       builder: (context, double value, child) {
//                         return Image.asset(
//                           'assets/images/blob.png',
//                           width: value,
//                           fit: BoxFit.cover,
//                         );
//                       },
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 40,
//                     left: MediaQuery.of(context).size.width * 0.5,
//                     child: const Text(
//                       'Account',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 10,
//                     left: MediaQuery.of(context).size.width * 0.16,
//                     child: GestureDetector(
//                       onTap: () {
//                         //context.read<AccountCubit>().enlargeImage();
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return Avatar(
//                               GetIt.instance.get<UserModel>().photoUrl,
//                               radius: 150,
//                               hasStatus: false,
//                             ); // Custom dialog widget with Hero animation
//                           },
//                         );
//                       },
//                       child: BlocBuilder<AuthCubit, AuthState>(
//                           builder: (context, state) {
//                         return BlocBuilder<AccountCubit, AccountState>(
//                             builder: (context, state) {
//                           return CircleAvatar(
//                               radius: context.read<AccountCubit>().sizeImage,
//                               backgroundColor: Colors.white,
//                               child: Avatar(
//                                 GetIt.instance.get<UserModel>().photoUrl,
//                                 radius: 90,
//                                 hasStatus: false,
//                               ));
//                         });
//                       }),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     left: MediaQuery.of(context).size.width * 0.30,
//                     child: GestureDetector(
//                       onTap: () {
//                         //context.read<AccountCubit>().enlargeImageDog();
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return Avatar(
//                               GetIt.instance.get<DogModel>().photoUrl,
//                               radius: 150,
//                               hasStatus: false,
//                             ); // Custom dialog widget with Hero animation
//                           },
//                         );
//                       },
//                       child: BlocBuilder<AuthCubit, AuthState>(
//                           builder: (context, state) {
//                         return BlocBuilder<AccountCubit, AccountState>(
//                             builder: (context, state) {
//                           return context.read<AccountCubit>().state ==
//                                   HideImage()
//                               ? const SizedBox()
//                               : CircleAvatar(
//                                   radius:
//                                       context.read<AccountCubit>().sizeImageDog,
//                                   backgroundColor: Colors.white,
//                                   child: Avatar(
//                                     GetIt.instance.get<DogModel>().photoUrl,
//                                     radius: 70,
//                                     hasStatus: false,
//                                   ));
//                         });
//                       }),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Column(
//               children: [
//                 AccountTile(
//                     icon: CustomIcons.paw,
//                     title: 'My dog info'.tr(),
//                     onTap: () =>
//                         Navigator.pushNamed(context, '/account/my-dog-info')),
//                 AccountTile(
//                     icon: CustomIcons.profile,
//                     title: 'My info'.tr(),
//                     onTap: () =>
//                         Navigator.pushNamed(context, '/account/my-info')),
//                 AccountTile(
//                     icon: CustomIcons.bulldogSvg,
//                     title: 'Friends'.tr(),
//                     onTap: () =>
//                         Navigator.pushNamed(context, '/account/friends')),
//                 AccountTile(
//                     icon: CustomIcons.settings,
//                     title: 'Settings'.tr(),
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => SettingScreen(),
//                       ));
//                     }),
//                 AccountTile(
//                     icon: CustomIcons.terms,
//                     title: 'Terms and conditions'.tr(),
//                     onTap: () => Navigator.pushNamed(context, '/auth/terms')),
//                 const Divider(height: 24, indent: 24, endIndent: 24),
//                 AccountTile(
//                     icon: CustomIcons.logout,
//                     title: 'Logout'.tr(),
//                     onTap: () {
//                       context.read<AuthCubit>().signOut();
//                       PreferencesService.clearStorage();
//                       HiveStorageService.deleteKey(key: 'userToken');
//                       Navigator.pushNamedAndRemoveUntil(
//                           context, '/auth/login', (route) => false);
//                     }),
//               ],
//             )
//           ],
//         ),
