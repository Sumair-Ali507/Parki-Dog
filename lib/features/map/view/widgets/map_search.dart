import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/widgets/search_field.dart';
import 'package:parki_dog/features/map/cubit/map_cubit.dart';

class MapSearch extends StatelessWidget {
  const MapSearch({super.key, required this.userLocation, required this.countryCode, this.focusNode});

  final LatLng userLocation;
  final String countryCode;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      child: Column(
        children: [
          SearchField(
            //
            focusNode: focusNode,
            placeholder: 'Search for a park'.tr(),
            onChanged: (input) async {
              await context.read<MapCubit>().parkTextSearch(
                    input,
                    userLocation,
                    countryCode,
                  );
            },
            color: Colors.white.withOpacity(0.8),
            textColor: const Color(0xff676767),
            borderColor: const Color(0xffc6c6c6),
          ),
          const SizedBox(height: 4),
          BlocBuilder<MapCubit, MapState>(
            buildWhen: (previous, current) => current is AutocompleteResults,
            builder: (context, state) {
              if (state is AutocompleteResults) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: state.predictions.length * 56 > 200 ? 200 : state.predictions.length * 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: state.predictions.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => context.read<MapCubit>().getSelectedPark(state.predictions[index].id!),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            state.predictions[index].name!,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 24,
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
