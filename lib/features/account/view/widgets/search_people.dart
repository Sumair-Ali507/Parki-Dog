import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';

import '../../../home/cubit/home_cubit.dart';
import '../../../home/view/widgets/avatar.dart';
import '../../data/account_repository.dart';

class SearchPeople extends StatelessWidget {
  const SearchPeople({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: context.read<AccountCubit>().searchNames.length,
      itemBuilder: (context, index) => FutureBuilder(
          future: AccountRepository.getDogData(
            doc: context.read<AccountCubit>().searchNames[index].dogs![0],
          ),
          builder: (context, dogSnapshot) {
            return ListTile(
              contentPadding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              leading: Avatar(context.read<AccountCubit>().searchNames[index].photoUrl, radius: 20),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '${context.read<AccountCubit>().searchNames[index].firstName} ${context.read<AccountCubit>().searchNames[index].lastName}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  context.read<HomeCubit>().sendFriendRequest(
                        GetIt.I.get<DogModel>().id!,
                        DogModel.fromMap(dogSnapshot.data),
                      );
                  context.read<AccountCubit>().showToaster();
                },
                icon: const Icon(Icons.add),
              ),
            );
          }),
    );
  }
}
