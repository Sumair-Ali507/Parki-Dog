import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/services/notifiactions/notification_service.dart';
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
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> const AllUserChatsScreen()));
                      },
                      notificationOnTap: () {},
                      isRedCircleChat: true,
                      isRedCircleNotification: true,
                    ),

                    const SizedBox(height: AppDouble.d32),
                    Text(LocaleKeys.home_getToKnowUs,
                        style: TextStyle(
                          fontSize: AppDouble.d18,
                          color: ColorsManager.black,
                          fontWeight: FontWeight.w800,
                        )).tr(),
                    const SizedBox(height: AppDouble.d12),
                    HowWorksMissionRow(howWorks: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HowWorksScreen()));
                    }, missionOnTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OurMissionScreen()));
                    }),

                    const SizedBox(height: AppDouble.d32),
                    const CurrentCheckIn(),

                    // const SizedBox(height: 16),
                    // const DoggyShoppy(),
                    // const DoggyShoppyWidget(),
                    // const SizedBox(height: 16),
                    // const GoogleAdBanners(),
                    // const SizedBox(height: 16),

                    const ParksNearby(),
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
