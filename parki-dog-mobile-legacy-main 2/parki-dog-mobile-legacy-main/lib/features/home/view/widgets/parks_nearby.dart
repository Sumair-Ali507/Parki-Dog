import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/navigation/cubit/navigation_cubit.dart';
import 'package:parki_dog/core/services/location/cubit/location_cubit.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/features/auth/view/widgets/link_button.dart';
import 'package:parki_dog/features/home/cubit/home_cubit.dart';
import 'package:parki_dog/features/home/view/widgets/park_tile.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class ParksNearby extends StatelessWidget {
  const ParksNearby({super.key});

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationCubit>().location;

    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Parks Nearby'.tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              LinkButton(
                text: 'View map'.tr(),
                onPress: () async {
                  context.read<NavigationCubit>().changeIndex(1);
                },
                color: AppColors.primary,
              ),
            ],
          ),
          // const SizedBox(height: 8),
          BlocBuilder<HomeCubit, HomeState>(
            bloc: context.read<HomeCubit>()..getNearbyParks(location),
            buildWhen: (previous, current) => current is NearbyParksNotFound || current is NearbyParksLoaded,
            builder: (context, state) {
              if (state is NearbyParksLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NearbyParksLoaded) {
                final parks = state.parks;

                return SizedBox(
                  height: parks.length > 4 ? 285 : null,
                  child: ListView.builder(
                    physics: parks.length > 4 ? null : const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: parks.length,
                    itemBuilder: (context, index) => ParkTile(parks[index], userLocation: location),
                  ),
                );
              } else {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        'No nearby parks'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      );
    });
  }
}

// SizedBox(
// height: 200,
// child: GridView.builder(
// padding: EdgeInsets.zero,
// scrollDirection: Axis.horizontal,
// clipBehavior: Clip.hardEdge,
// gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// childAspectRatio: 0.28, crossAxisCount: 2, mainAxisSpacing: 2, crossAxisSpacing: 2),
// shrinkWrap: true,
// itemCount: parks.length > 4 ? 4 : parks.length,
// itemBuilder: (context, index) => ParkTile(parks[index], userLocation: location),
// ),
// );
