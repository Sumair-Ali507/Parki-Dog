import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/services/notifiactions/notification_service.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/features/home/view/widgets/greeting.dart';

import '../../../chat/view/page/show_user_chats.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class Header extends StatelessWidget {
  Header({super.key});

  final notificationService = NotificationService();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Greeting(),
          Row(children: [
            CustomIcons.newNotification,
            const SizedBox(
              width: 15,
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AllUserChatsScreen(),
                  ));
                },
                child: CustomIcons.message),
          ]),

          // IconButton(
          //     onPressed: () async {
          //       // await notificationService.initializePlatformNotifications();
          //       // final result = await NotificationService.sendFcmNotification(
          //       //     title: 'hello',
          //       //     body: 'neik',
          //       //     token: GetIt.I.get<DogModel>().notificationToken!);
          //       // print('result is $result');
          //     },
          //     icon: CustomIcons.notification)
        ],
      );
    });
  }
}
