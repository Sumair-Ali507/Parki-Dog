import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/account/view/widgets/dog_general_info.dart';
import 'package:parki_dog/features/account/view/widgets/dog_unsocial_with.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

import '../../../../core/theme/icons/custom_icons.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../auth/data/user_model.dart';
import '../../../auth/view/widgets/link_button.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../data/account_repository.dart';

class DogInfoScreen extends StatelessWidget {
  const DogInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      buildWhen: (previous, current) => current is DogInfoUpdated,
      builder: (context, state) {
        return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            extendBodyBehindAppBar: true,
            body: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset(
                      'assets/images/blob.png',
                      color: AppColors.secondary,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      left: MediaQuery.of(context).size.width * 0.18,
                      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Avatar(
                            GetIt.instance.get<DogModel>().photoUrl ?? '',
                            radius: 48,
                            hasStatus: false,
                          ),
                        );
                      }),
                    ),
                    Positioned(
                      bottom: 30,
                      left: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GetIt.instance.get<DogModel>().name!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              GetIt.instance.get<DogModel>().breed!,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 135,
                      child: GestureDetector(
                        onTap: () async {
                          await context.read<AccountCubit>().pickImage(context: context);
                          await AccountRepository.uploadDogImage(context: context);
                          await context.read<AuthCubit>().retrieveUserData(GetIt.instance.get<UserModel>().id!);
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.black87,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      DogGeneralInfo(),
                      const SizedBox(height: 24),
                      DogUnsocialWith(),
                    ],
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }
}
// Positioned(
// bottom: 30,
// left: 105,
// child: LinkButton(
// text: 'Edit',
// edit: Colors.white,
// onPress: () async {
//
// },
// color: Colors.white,
// icon: const FaIcon(
// FontAwesomeIcons.came,
// size: 16,
// color: Colors.white,
// ),
// ),
// )
