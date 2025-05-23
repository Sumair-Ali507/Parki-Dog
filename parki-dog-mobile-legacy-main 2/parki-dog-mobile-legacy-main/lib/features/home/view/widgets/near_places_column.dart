import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../cubit/near_by_places_enum.dart';
import '../../cubit/near_places_pagination.dart';
import '../../data/park_model.dart';
import 'near_by_places_header.dart';
import 'near_places_button.dart';
import 'near_places_items.dart';

class NearPlacesColumn extends StatelessWidget {
  final List<ParkModel> parks;

  const NearPlacesColumn({super.key, required this.parks});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SelectNearByPlacesCubit()),
        BlocProvider(create: (context) => NearbyPlacesPaginationCubit()),
      ],
      child: BlocBuilder<SelectNearByPlacesCubit, NearbyPlacesEnum>(
        builder: (nearbyPlacesContext, nearbyPlacesState) {
          SelectNearByPlacesCubit nearbyPlacesCubit =
          nearbyPlacesContext.read<SelectNearByPlacesCubit>();
          return BlocBuilder<NearbyPlacesPaginationCubit, int>(
            builder: (paginationContext, visibleItemCount) {
              final bool canShowMore = visibleItemCount + 5 <= parks.length;
              final bool canShowLess = visibleItemCount > 5;

              return Column(
                children: [
                  NearbyPlacesHeader(mapOnTap: () {}),
                  SizedBox(
                      height: AppDouble.d35,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => NearPlacesButton(
                            text: NearbyPlacesEnum.values[index].name,
                            isSelected: nearbyPlacesState ==
                                NearbyPlacesEnum.values[index],
                            onTap: index != AppInt.i0
                                ? null
                                : () {
                              nearbyPlacesCubit.selectPlace(
                                  NearbyPlacesEnum.values[index]);
                            },
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            width: AppDouble.d8,
                          ),
                          itemCount: AppInt.i4)),
                  const SizedBox(height: AppDouble.d20),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => NearbyPlacesItem(
                        rating: parks[index].rating?.round() ?? 0,
                        dogCount: parks[index]
                            .currentCheckins
                            ?.map((e) => e.dog
                        )
                            .length ??
                            AppInt.i0,
                        appLocation: parks[index].location1!,
                          placeName: parks[index].name ?? '',
                        reviewsCount:
                        parks[index].reviews?.length ?? AppInt.i0,
                      ),
                      separatorBuilder: (context, index) => Divider(
                        thickness: AppDouble.d1,
                        color: ColorsManager.grey100,
                        height: 16,
                      ),
                      itemCount: visibleItemCount.clamp(0, parks.length)),
                  // Ensure itemCount is within bounds
                  const SizedBox(height: AppDouble.d20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: canShowMore
                            ? () {
                          paginationContext
                              .read<NearbyPlacesPaginationCubit>()
                              .showMore(parks.length);
                        }
                            : null, // Disable button if cannot show more
                        child: const Text('Show More'),
                      ),
                      const SizedBox(width: AppDouble.d20),
                      TextButton(
                        onPressed: canShowLess
                            ? () {
                          paginationContext
                              .read<NearbyPlacesPaginationCubit>()
                              .showLess();
                        }
                            : null, // Disable button if cannot show less
                        child: const Text('Show Less'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
