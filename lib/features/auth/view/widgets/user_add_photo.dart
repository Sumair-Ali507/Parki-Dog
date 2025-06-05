import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/core/resources_manager/strings_manager.dart';

class UserAddPhoto extends StatelessWidget {
  const UserAddPhoto({super.key, this.placeholderAsset = 'assets/images/profile placeholder.png'});

  final String placeholderAsset;
  @override
  Widget build(BuildContext context) {
    return StringsManager.socialProfilePicture != null
        ? Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                    fit: BoxFit.fill, image: CachedNetworkImageProvider(StringsManager.socialProfilePicture!))),
          )
        : BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return state is LoadUserUploadImageState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state is SuccessUserUploadImageState
                      ? InkWell(
                          onTap: () => context.read<AuthCubit>().uploadUserImage(context: context),
                          child: SizedBox(
                            height: 150,
                            child: Stack(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(fit: BoxFit.fill, image: FileImage(state.image))),
                                ),
                                const PositionedDirectional(
                                  bottom: 10,
                                  start: 60,
                                  child: Padding(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                      )),
                                ),
                              ],
                            ),
                          ))
                      : Column(
                          children: [
                            InkWell(
                              onTap: () => context.read<AuthCubit>().uploadUserImage(context: context),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Image.asset(
                                    placeholderAsset,
                                    width: MediaQuery.of(context).size.width * 0.27,
                                    fit: BoxFit.contain,
                                  ),
                                  Padding(padding: const EdgeInsets.only(bottom: 8), child: CustomIcons.camera),
                                ],
                              ),
                            ),
                            Text('Add photo'.tr(),
                                style: const TextStyle(
                                    color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        );
            },
          );
  }
}
