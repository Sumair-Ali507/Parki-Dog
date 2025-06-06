import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/data/friend_model.dart';
import 'package:parki_dog/features/home/cubit/home_cubit.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

class BlurredDogTile extends StatelessWidget {
  const BlurredDogTile(this.dog, {super.key});

  final DogModel dog;

  @override
  Widget build(BuildContext context) {
    final user = GetIt.I.get<DogModel>();

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          (current is SafetyStatusChanged && current.id == dog.id!) ||
          (current is FriendshipStatusChanged && current.id == dog.id!),
      builder: (context, state) {
        return ListTile(
          horizontalTitleGap: 8,
          contentPadding: EdgeInsets.zero,
          leading: Avatar(dog.photoUrl, radius: 21, hasStatus: false),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    dog.name!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  dog.gender == 'Male'
                      ? Image.asset(
                          'assets/icons/male.png',
                          color: Colors.white.withOpacity(0.7),
                          height: 16,
                        )
                      : Image.asset(
                          'assets/icons/female.png',
                          color: Colors.white.withOpacity(0.7),
                          height: 16,
                        ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  dog.breed!,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white.withOpacity(0.6)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: dog.id == user.id
              ? Text('(You)'.tr(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //*
                    if (user.friends.any((element) => element.id == dog.id!)) _buildFriendshipIcon(user, dog.id!),
                    if (user.enemies.contains(dog.id!))
                      SvgPicture.asset(
                        'assets/icons/hand.svg',
                        colorFilter: const ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                      ),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.white),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.black.withOpacity(0.5),
                      position: PopupMenuPosition.under,
                      itemBuilder: (context) => [
                        _buildFriendshipMenuItem(context, user, dog),
                        const PopupMenuItem(
                            padding: EdgeInsets.zero,
                            enabled: false,
                            height: 1,
                            child: Divider(
                              color: Colors.white,
                            )),
                        user.enemies.contains(dog.id!)
                            ? PopupMenuItem(
                                onTap: () => context.read<HomeCubit>().markSafe(user.id!, dog.id!),
                                child: Row(
                                  children: [
                                    CustomIcons.checkHeart,
                                    const SizedBox(width: 8),
                                    Text('Mark safe'.tr(),
                                        style: const TextStyle(color: Color(0xff06851A), fontSize: 12)),
                                  ],
                                ),
                              )
                            : PopupMenuItem(
                                onTap: () => context.read<HomeCubit>().markUnsafe(user.id!, dog.id!),
                                child: Row(
                                  children: [
                                    CustomIcons.hand,
                                    const SizedBox(width: 8),
                                    Text('Mark hostile'.tr(),
                                        style: const TextStyle(color: Color(0xffC70404), fontSize: 12)),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildFriendshipIcon(DogModel user, String friendId) {
    final friends = user.friends;
    final friend =
        friends.firstWhere((element) => element.id == friendId, orElse: () => FriendModel(id: '', status: ''));

    switch (friend.status) {
      case 'sent':
        return CustomIcons.bulldogYellow;
      case 'received':
        return CustomIcons.bulldogYellow;
      case 'accepted':
        return CustomIcons.bulldogCheck;
      default:
        return const SizedBox.shrink();
    }
  }

  PopupMenuItem _buildFriendshipMenuItem(BuildContext context, DogModel user, DogModel friendModel) {
    final friends = user.friends;
    final friend =
        friends.firstWhere((element) => element.id == friendModel.id!, orElse: () => FriendModel(id: '', status: ''));

    final homeCubit = context.read<HomeCubit>();
    switch (friend.status) {
      case 'sent':
        return PopupMenuItem(
          onTap: () => homeCubit.cancelFriendRequest(user.id!, friendModel.id!),
          child: Row(
            children: [
              CustomIcons.bulldogYellow,
              const SizedBox(width: 8),
              Text('Cancel request'.tr(), style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
            ],
          ),
        );

      case 'received':
        return PopupMenuItem(
          onTap: () => homeCubit.acceptFriendRequest(user, friendModel),
          child: Row(
            children: [
              CustomIcons.bulldogGreen,
              const SizedBox(width: 8),
              Text('Accept request'.tr(), style: const TextStyle(color: Color(0xff06851A), fontSize: 12)),
            ],
          ),
        );

      case 'accepted':
        return PopupMenuItem(
          onTap: () => homeCubit.removeFriend(user.id!, friendModel.id!),
          child: Row(
            children: [
              CustomIcons.bulldogRed,
              const SizedBox(width: 8),
              Text('Remove friend'.tr(), style: const TextStyle(color: Color(0xffC70404), fontSize: 12)),
            ],
          ),
        );

      default:
        return PopupMenuItem(
          onTap: () => homeCubit.sendFriendRequest(user.id!, friendModel),
          child: Row(
            children: [
              CustomIcons.bulldogAdd,
              const SizedBox(width: 8),
              Text('Add friend'.tr(), style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
    }
  }
}
