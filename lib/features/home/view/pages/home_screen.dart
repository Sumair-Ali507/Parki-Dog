import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parki_dog/core/services/notifiactions/notification_service.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/features/auth/data/auth_repository.dart';
import 'package:parki_dog/features/chat/view/page/show_user_chats.dart';
import 'package:parki_dog/features/home/data/park_model.dart';
import 'package:parki_dog/features/home/view/pages/coming_soon.dart';
import 'package:parki_dog/features/home/view/pages/tell_feeback.dart';
import 'package:parki_dog/features/home/view/widgets/current_check_in.dart';
import 'package:parki_dog/features/home/view/widgets/doggy_shoppy.dart';
import 'package:parki_dog/features/home/view/widgets/header.dart';
import 'package:parki_dog/features/home/view/widgets/our_mission_screen.dart';
import 'package:parki_dog/features/home/view/widgets/parks_nearby.dart';
import 'package:parki_dog/features/shop/cubit/shop_cubit.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../chat/data/chat_repository.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

import '../widgets/how_works_mission.dart';
import '../widgets/how_works_mission_row.dart';
import '../widgets/near_places_column.dart';

class HomeScreen extends StatefulWidget {
  final List<ParkModel> parks;
  const HomeScreen({super.key, required this.parks});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  requestNotificationPermession() async {
    await NotificationService.requestPermission();
    if (context.mounted)
      NotificationService.handleMessageReseved(context: context);
  }

  @override
  initState() {
    super.initState();
    AuthRepository.createFireBaseToken();
    requestNotificationPermession();
    ShopCubit.get(context).getAllShopItems();
    ChatRepository.getAllUserChats(context);
    context.read<LangCubit>().setDataStorage();
  }

  final events = [
    EventItem(time: '12:00 pm', title: 'Park Visit', isPast: true),
    EventItem(time: '01:00 pm', title: 'Clinic Session', isPast: false),
  ];
  final places = [
    PlacesFilter(name: 'Parks', isSelected: true),
    PlacesFilter(name: 'Clinics', isSelected: false),
    PlacesFilter(name: 'Beaches', isSelected: false),
    PlacesFilter(name: 'Washing Shops', isSelected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppDouble.d16, horizontal: AppDouble.d16),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    HomeAppBar(
                      chatOnTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllUserChatsScreen(),
                          ),
                        );
                      },
                      notificationOnTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllUserChatsScreen(),
                          ),
                        );
                      },
                      isRedCircleChat: true,
                      isRedCircleNotification: true,
                    ),

                    const SizedBox(height: AppDouble.d32),
                    TodaysActivitiesWidget(events: events),
                    // const SizedBox(height: AppDouble.d32),
                    const CurrentCheckIn(),
                    NearbyPlacesWidget(places: places),
                    ShopSectionWidget(),
                    AdventuresSectionWidget(),
                    SuggestedSectionWidget(),
                    TopTrainersSectionWidget(),
                    AdoptionSectionWidget(),
                    // const SizedBox(height: 16),
                    // const DoggyShoppy(),
                    // const DoggyShoppyWidget(),
                    // const SizedBox(height: 16),
                    // const GoogleAdBanners(),
                    // const SizedBox(height: 16),

                    // const ParksNearby(),
                    ComingSooon(),
                    const TellFeedBack(),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 7),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class AdoptionSectionWidget extends StatelessWidget {
  const AdoptionSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Up For Adoption",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text("More", style: TextStyle(color: AppColors.primary)),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 185.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 16.w),
                  width: 100.w,
                  height: 175.h,
                  child: Column(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        height: 100.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Image.network(
                            fit: BoxFit.cover,
                            'https://t3.ftcdn.net/jpg/02/68/21/24/360_F_268212419_ZBJvlgVezhjziaP9aynnMGMLOvjUgNG5.jpg'),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Banana',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          SvgPicture.asset('assets/new-images/man.svg')
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        'Labrador',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF808086),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        '\$500',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      )
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}

class TopTrainersSectionWidget extends StatelessWidget {
  const TopTrainersSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Top Notch Trainers",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text("More", style: TextStyle(color: AppColors.primary)),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            ListView.builder(
                padding: EdgeInsets.only(top: 16.h),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            width: 42,
                            height: 42,
                            child: Image.network(
                                fit: BoxFit.cover,
                                'https://media.istockphoto.com/id/1040501222/photo/portrait-of-a-personal-trainer-in-the-gym.jpg?s=612x612&w=0&k=20&c=Xdmp8LM2OCBkwtbWELRkYoQlsT9OZECtq--7gE5BPLg='),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'John Doe',
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/icons/locationPin.svg'),
                                  SizedBox(
                                    width: 2.5,
                                  ),
                                  Text(
                                    '\$15',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary),
                                  ),
                                  Text(
                                    '/session',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return SvgPicture.asset(
                                    'assets/icons/bone-filled.svg',
                                  );
                                }),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                '(12 reviews)',
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFF5D5C64)),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Divider(
                        color: Color(0xFF5D5C64).withOpacity(0.2),
                      ),
                    ],
                  );
                })
          ],
        ),
      ],
    );
  }
}

class SuggestedSectionWidget extends StatelessWidget {
  const SuggestedSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Suggested Friends",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: 24,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 340.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 16.w),
                  width: 220.w,
                  height: 340.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Color(0xFFF3F4F6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 220.w,
                        height: 220.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfJJJgYghNibFfJGY6H8w99z-JinmYIroEtw&s'),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            topRight: Radius.circular(16.r),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  margin: EdgeInsets.all(8.sp),
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      shape: BoxShape.circle),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://thumbs.dreamstime.com/b/portrait-charming-beautiful-woman-attractive-girl-bundled-her-long-hair-gorgeous-has-nice-skin-face-glamour-eyes-look-126066321.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Sarah Lorenzo',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        child: Row(
                          children: [
                            Text(
                              'Rex',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 4.w),
                            SvgPicture.asset('assets/new-images/man.svg'),
                            Text(
                              ' - ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF808086),
                              ),
                            ),
                            Text(
                              'German',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF808086),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              width: 16.w,
                              height: 16.h,
                              'assets/icons/bulldog.svg',
                              colorFilter: ColorFilter.mode(
                                  Colors.black, BlendMode.srcIn),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              '14 Mutual Friends',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF808086),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 90.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppColors.primary,
                                ),
                                child: Center(
                                  child: Text(
                                    'Add Friend',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 90.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                      color: Color(0xFF808086), width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}

class AdventuresSectionWidget extends StatelessWidget {
  const AdventuresSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Adventures",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text("More", style: TextStyle(color: AppColors.primary)),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 184.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.only(right: 16.w),
                      height: 245.h,
                      width: 184.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSses3EYlid1Tzas_CrIooT8I0r6Me_97eIPg&s',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // White border
                              width: 2.0,
                            ),
                            shape: BoxShape.circle),
                        child: ClipOval(
                          child: Image.network(
                            'https://media.istockphoto.com/id/2060179569/photo/cheerful-portrait-of-young-blonde-girl-looking-at-camera-over-yellow-background.jpg?s=612x612&w=0&k=20&c=t4NrSp4VOQg9Fq2zhEDGaJuGQU6NlAP_Nf8xDKLAK4E=',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 18,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // White border
                              width: 2.0,
                            ),
                            shape: BoxShape.circle),
                        child: ClipOval(
                          child: Image.network(
                            'https://cdn.shopify.com/s/files/1/0086/0795/7054/files/Golden-Retriever.jpg?v=1645179525',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 7,
                      left: 45,
                      child: Text(
                        'Sarah',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hike trails!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/calendar.svg',
                                width: 16.w,
                                height: 16.h,
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                '13/02/2024',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/icons/clock.svg',
                                width: 16.w,
                                height: 16.h,
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                '08:30 PM : 10:30 PM',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/icons/locationPin.svg',
                                width: 16.w,
                                height: 16.h,
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                'Milano',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
        )
      ],
    );
  }
}

class ShopSectionWidget extends StatelessWidget {
  const ShopSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Shop",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text("More", style: TextStyle(color: AppColors.primary)),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 185.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 16.w),
                  width: 100.w,
                  height: 175.h,
                  child: Column(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        height: 100.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Image.network(
                            fit: BoxFit.cover,
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQX4BK6fkvWYnhGGSQiQjCy4vOpqhLQQqkV7Q&s'),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'Cake',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return SvgPicture.asset(
                              'assets/icons/bone-filled.svg',
                              width: 12.w,
                              height: 12.h,
                            );
                          }),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            '(9)',
                            style: TextStyle(
                                fontSize: 9.sp, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$15',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            '\$15',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFFA6A5AA),
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}

class NearbyPlacesWidget extends StatelessWidget {
  const NearbyPlacesWidget({
    super.key,
    required this.places,
  });

  final List<PlacesFilter> places;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Nearby Places",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text("Map", style: TextStyle(color: AppColors.primary)),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: places.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  margin: EdgeInsets.only(right: 8.w),
                  height: 30,
                  decoration: BoxDecoration(
                    border: !places[index].isSelected
                        ? Border.all(color: AppColors.primary.withOpacity(0.2))
                        : null,
                    borderRadius: BorderRadius.circular(16.r),
                    color: places[index].isSelected
                        ? AppColors.primary.withOpacity(0.3)
                        : null,
                  ),
                  child: Center(child: Text(places[index].name)),
                );
              }),
        ),
        SizedBox(
          height: 8.h,
        ),
        Column(
          children: [
            ListView.builder(
                padding: EdgeInsets.only(top: 16.h),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            width: 42,
                            height: 42,
                            child: Image.network(
                                fit: BoxFit.cover,
                                'https://media.istockphoto.com/id/597939586/photo/group-of-little-trees-growing-in-garden.jpg?s=612x612&w=0&k=20&c=n0wT9OksXbQoFmiBO4Z3dIPYjd1X5o3foJDJvjlhQxE='),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monte Orlando',
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/icons/locationPin.svg'),
                                  SizedBox(
                                    width: 2.5,
                                  ),
                                  Text(
                                    '1.5km away',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Color(0xFF5D5C64)),
                                  ),
                                  Text(
                                    ' \u2022 ',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFF5D5C64),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/paw.svg',
                                    width: 16,
                                    height: 16,
                                    color: Color(0xFF5D5C64),
                                  ),
                                  Text(
                                    ' 2 dogs ',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFF5D5C64),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return SvgPicture.asset(
                                    'assets/icons/bone-filled.svg',
                                  );
                                }),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                '(12 reviews)',
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFF5D5C64)),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Divider(
                        color: Color(0xFF5D5C64).withOpacity(0.2),
                      ),
                    ],
                  );
                })
          ],
        ),
      ],
    );
  }
}

class TodaysActivitiesWidget extends StatelessWidget {
  const TodaysActivitiesWidget({
    super.key,
    required this.events,
  });

  final List<EventItem> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Section title
        Row(
          children: [
            const Text(
              "Today's Activities",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text("More", style: TextStyle(color: AppColors.primary)),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),

        // Timeline items
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final activity = events[index];

            return TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.01,
              isFirst: index == 0,
              isLast: index == events.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 14,
                color: activity.isPast
                    ? Colors.green.shade200
                    : Colors.green.shade900,
              ),
              beforeLineStyle: LineStyle(
                color: Colors.green.shade200,
                thickness: 2,
              ),
              afterLineStyle: LineStyle(
                color: Colors.green.shade200,
                thickness: 2,
              ),
              endChild: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                child: Row(
                  children: [
                    // Time
                    SizedBox(
                      width: 70,
                      child: Text(
                        activity.time,
                        style: TextStyle(
                          color: activity.isPast
                              ? Colors.grey
                              : Colors.green.shade900,
                          decoration: activity.isPast
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Title
                    Expanded(
                      child: Text(
                        activity.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // Dots (three dot menu)
                    const Icon(Icons.more_vert, size: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class EventItem {
  final String time;
  final String title;
  final bool isPast;

  EventItem({required this.time, required this.title, required this.isPast});
}

class PlacesFilter {
  final String name;
  final bool isSelected;

  PlacesFilter({required this.name, required this.isSelected});
}
