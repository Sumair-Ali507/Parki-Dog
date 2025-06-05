import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parki_dog/features/account/data/account_repository.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/dog_model.dart';
import '../../../home/view/widgets/avatar.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class FriendProfile extends StatelessWidget {
  final DogModel friendDog;
  const FriendProfile({Key? key, required this.friendDog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'General Info'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leadingWidth: 100,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: StreamBuilder(
            stream: AccountRepository.db.collection('users').doc(friendDog.userId).snapshots(),
            builder: (context, snapshot) {
              dynamic friendData = snapshot.data?.data();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) => SizedBox(
                        height: constraints.maxWidth * 0.48 + 20,
                        child: Stack(
                          // alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(
                              'assets/images/blob-2.png',
                              color: AppColors.secondary,
                              fit: BoxFit.cover,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Avatar(
                                  friendData['photoUrl'] ?? '',
                                  radius: 48,
                                  hasStatus: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              'Friend info'.tr(),
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                          ),

                          FriendProfileInfo(
                            leading: 'Full Name'.tr(),
                            trailing: '${friendData['firstName']} ${friendData['lastName']}',
                          ),
                          FriendProfileInfo(
                            leading: 'Email',
                            trailing: friendData['email'],
                          ),
                          FriendProfileInfo(
                            leading: 'Gender'.tr(),
                            trailing: friendData['gender'],
                          ),
                          friendDog.photoUrl == null
                              ? const SizedBox()
                              : Center(
                                  child: CircleAvatar(
                                    radius: 40, // adjust the radius as needed
                                    backgroundImage: (friendDog.photoUrl != null)
                                        ? NetworkImage(friendDog.photoUrl!)
                                        : null, // set to null if imageUrl is null or empty
                                  ),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              'Dog info'.tr(),
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                          ),

                          FriendProfileInfo(
                            leading: 'Name'.tr(),
                            trailing: friendDog.name!,
                          ),
                          FriendProfileInfo(
                            leading: 'Breed'.tr(),
                            trailing: friendDog.breed!,
                          ),
                          FriendProfileInfo(
                            leading: 'Gender'.tr(),
                            trailing: friendDog.gender!,
                          ), // const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    });
  }
}

class FriendProfileInfo extends StatelessWidget {
  final String leading;
  final String trailing;
  const FriendProfileInfo({
    super.key,
    required this.leading,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        leading,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      trailing: Text(
        trailing,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }
}
