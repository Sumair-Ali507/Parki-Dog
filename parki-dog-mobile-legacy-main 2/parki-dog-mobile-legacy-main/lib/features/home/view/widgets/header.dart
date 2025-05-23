import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parki_dog/core/services/notifiactions/notification_service.dart';
import 'package:parki_dog/features/chat/view/page/show_user_chats.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/values_manager.dart';
import 'greeting.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback? chatOnTap;
  final VoidCallback? notificationOnTap;
  final bool isRedCircleChat;
  final bool isRedCircleNotification;

  const HomeAppBar({
    super.key,
    this.chatOnTap,
    this.notificationOnTap,
    this.isRedCircleChat = false,
    this.isRedCircleNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: SvgPicture.asset(ImageAssets.parkiDogAppBar)),
        Row(
          children: [
            HomeAppBarIcon(
              onTap: ()=> AllUserChatsScreen(),
              svgAssetName: ImageAssets.chatBubbles,
              isRedCircle: isRedCircleChat,
            ),
             SizedBox(width: AppDouble.d8),
            HomeAppBarIcon(
              onTap: ()=> NotificationService(),
              svgAssetName: ImageAssets.notification,
              isRedCircle: isRedCircleNotification,
            ),
          ],
        )
      ],
    );
  }
}
