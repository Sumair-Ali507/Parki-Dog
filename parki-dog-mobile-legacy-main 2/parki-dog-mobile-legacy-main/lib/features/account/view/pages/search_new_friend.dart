import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';

import '../../../auth/data/dog_model.dart';
import '../../../home/cubit/home_cubit.dart';
import '../../../home/view/widgets/avatar.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../cubit/account_cubit.dart';
import '../../data/account_repository.dart';
import '../widgets/search_people.dart';

class SearchNewFriend extends StatelessWidget {
  const SearchNewFriend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              forceMaterialTransparency: true,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: SizedBox(
                height: 50,
                child: TextFormField(
                  onTapOutside: (v) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  controller: context.read<AccountCubit>().friendSearchController,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    suffixIconColor: Colors.black,
                    prefixIconColor: Colors.grey,
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: InkWell(
                      onTap: () => context.read<AccountCubit>().clearSearch(),
                      child: const Icon(
                        Icons.close,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                  onChanged: (v) {
                    context.read<AccountCubit>().searchUsersNames(text: v);
                  },
                ),
              ),
            ),
            body: StreamBuilder(
              stream: AccountRepository.db.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No data available".tr()),
                  );
                }
                List<UserModel> users = snapshot.data!.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
                context.read<AccountCubit>().setUserNames(list: users);
                return context.read<AccountCubit>().searchNames.isEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var userDoc = snapshot.data?.docs[index];
                          var dogDoc = userDoc?['dogs'][0];

                          return FutureBuilder(
                            future: AccountRepository.getDogData(doc: dogDoc),
                            builder: (context, dogSnapshot) {
                              if (dogSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: const CircularProgressIndicator(),
                                  ),
                                );
                              } else {
                                var dogData = dogSnapshot.data;
                                return ListTile(
                                  contentPadding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                                  onTap: () {},
                                  subtitle: SizedBox(
                                    child: Text(
                                      dogData?['name'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  leading: Avatar(userDoc?['photoUrl'], radius: 20),
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      '${userDoc?['firstName']} ${userDoc?['lastName']}',
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
                              }
                            },
                          );
                        },
                      )
                    : const SearchPeople();
              },
            ),
          );
        });
      },
    );
  }
}
