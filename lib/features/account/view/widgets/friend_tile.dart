import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/features/account/view/pages/friend_profile.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/chat/data/chat_repository.dart';
import 'package:parki_dog/features/home/cubit/home_cubit.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

import '../../../chat/view/page/chat_screen.dart';

class FriendTile extends StatelessWidget {
  const FriendTile(this.data, {super.key});

  final Map<String, DogModel> data;

  @override
  Widget build(BuildContext context) {
    final friend = data.values.first;

    return ListTile(
      horizontalTitleGap: 8,
      contentPadding: EdgeInsets.zero,
      leading: Avatar(friend.photoUrl, radius: 21, hasStatus: false),
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    friend.name!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary),
                  ),
                  const SizedBox(width: 4),
                  friend.gender == 'Male'
                      ? Image.asset(
                          'assets/icons/male.png',
                          color: AppColors.primary,
                          height: 16,
                        )
                      : Image.asset(
                          'assets/icons/female.png',
                          color: AppColors.primary,
                          height: 16,
                        ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * (friend.currentCheckIn == null ? 0.55 : 0.25),
                child: Text(
                  friend.breed!,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: AppColors.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (friend.currentCheckIn != null)
            Row(
              children: [
                Image.asset(
                  'assets/images/icon-max.png',
                  height: 20,
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    friend.currentCheckIn!.parkName,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        ],
      ),
      trailing: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) => current is FriendshipStatusChanged && current.id == friend.id!,
        builder: (context, state) {
          return _buildTrailing(context, state is FriendshipStatusChanged ? state.status : data.keys.first, friend);
        },
      ),
    );
  }

  Widget _buildTrailing(BuildContext context, String status, DogModel friend) {
    final homeCubit = context.read<HomeCubit>();
    final user = GetIt.instance.get<DogModel>();

    switch (status) {
      case 'sent':
        return SizedBox(
          width: 70,
          child: PopupMenuButton(
            icon: Text('pending'.tr(), style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.black.withOpacity(0.5),
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => homeCubit.cancelFriendRequest(user.id!, friend.id!),
                child: Row(
                  children: [
                    CustomIcons.bulldogYellow,
                    const SizedBox(width: 8),
                    Text('Cancel request'.tr(), style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        );

      case 'received':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(CupertinoIcons.checkmark_alt, color: Color(0xff06851A)),
              onPressed: () => homeCubit.acceptFriendRequest(user, friend),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(CupertinoIcons.xmark, color: Color(0xffC70404), size: 20),
              onPressed: () => homeCubit.cancelFriendRequest(user.id!, friend.id!),
            ),
          ],
        );
      case 'accepted':
        return PopupMenuButton(
          icon: const Icon(Icons.more_horiz),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.black.withOpacity(0.5),
          position: PopupMenuPosition.under,
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FriendProfile(
                    friendDog: friend,
                  ),
                ));
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text('Profile'.tr(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () {
                ChatRepository.getFriendName(friendId: friend.userId!);
                ChatRepository.findDocumentPath(idFrom: user.userId!, idTo: friend.userId!)
                    .whenComplete(() => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            fromId: user.userId!,
                            toId: friend.userId!,
                            friendName: ChatRepository.friendName,
                          ),
                        )));
              },
              child: Row(
                children: [
                  CustomIcons.message,
                  const SizedBox(width: 8),
                  Text('Chat'.tr(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () => context.read<HomeCubit>().removeFriend(user.id!, friend.id!),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xffC70404),
                  ),
                  const SizedBox(width: 8),
                  Text('Remove friend'.tr(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ],
        );

      case 'cancelled':
        return SizedBox(
          width: 70,
          child: Text('Cancelled'.tr(), style: const TextStyle(color: Color(0xffC70404), fontSize: 12)),
        );

      case 'declined':
        return SizedBox(
          width: 70,
          child: Text('Declined'.tr(), style: const TextStyle(color: Color(0xffC70404), fontSize: 12)),
        );

      case 'removed':
        return SizedBox(
          width: 70,
          child: Text('Removed'.tr(), style: const TextStyle(color: Color(0xffC70404), fontSize: 12)),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
