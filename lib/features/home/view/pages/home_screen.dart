import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/services/notifiactions/notification_service.dart';
import 'package:parki_dog/features/auth/data/auth_repository.dart';
import 'package:parki_dog/features/home/view/widgets/current_check_in.dart';
import 'package:parki_dog/features/home/view/widgets/doggy_shoppy.dart';
import 'package:parki_dog/features/home/view/widgets/header.dart';
import 'package:parki_dog/features/home/view/widgets/parks_nearby.dart';
import 'package:parki_dog/features/shop/cubit/shop_cubit.dart';
import '../../../chat/data/chat_repository.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../../park/data/park_repository.dart';
import '../../../shop/view/widget/doggy_shoppy_widget.dart';
import '../widgets/google_ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  requestNotificationPermession() async {
    await NotificationService.requestPermission();
    if (context.mounted) NotificationService.handleMessageReseved(context: context);
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Header(),
                      const SizedBox(height: 24),
                      const CurrentCheckIn(),
                      const ParksNearby(),
                      const SizedBox(height: 16),
                      const DoggyShoppy(),
                      const DoggyShoppyWidget(),
                      const SizedBox(height: 16),
                      const GoogleAdBanners(),
                      const SizedBox(height: 16),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
