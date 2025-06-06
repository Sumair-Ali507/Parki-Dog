import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/account/view/pages/search_new_friend.dart';
import 'package:parki_dog/features/account/view/widgets/friend_tile.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friends = GetIt.instance.get<DogModel>().friends;

    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          title: Text(
            'My friends'.tr(),
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SearchNewFriend(),
              )),
              icon: const Icon(Icons.search, color: Colors.black),
            ),
          ],
        ),
        body: BlocBuilder<AccountCubit, AccountState>(
          bloc: context.read<AccountCubit>()..getFriends(friends),
          buildWhen: (previous, current) => current is FriendsLoaded,
          builder: (context, state) {
            if (state is FriendsLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.friends.length,
                itemBuilder: (context, index) {
                  final friend = state.friends[index];
                  return FriendTile(friend);
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );
    });
  }
}
