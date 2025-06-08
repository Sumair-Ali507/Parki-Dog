import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parki_dog/core/services/location/cubit/location_cubit.dart';
import 'package:parki_dog/core/utils.dart';
import 'package:parki_dog/features/map/cubit/map_cubit.dart';
import 'package:parki_dog/features/map/view/widgets/map_search.dart';
import 'package:parki_dog/features/map/view/widgets/search_this_area.dart';
import 'package:latlong2/latlong.dart' as lat_lng2;
import 'package:parki_dog/features/park/data/park_repository.dart';
import '../../../home/view/widgets/google_ads.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../widgets/all_country_search.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    ParkRepository.getContext(context);
    final locationCubit = context.watch<LocationCubit>();
    final location = locationCubit.location;
    return BlocBuilder<MapCubit, MapState>(builder: (context, state) {
      return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  BlocBuilder<MapCubit, MapState>(
                    buildWhen: (previous, current) => current is MarkersLoaded || current is CityMarkersLoaded,
                    builder: (context, state) {
                      return GoogleMap(
                        mapToolbarEnabled: false,
                        onMapCreated: (controller) async {
                          controller.setMapStyle(Utils.getMapStyling());
                          _controller = controller;

                          final mapCubit = context.read<MapCubit>();
                          mapCubit.center = location;
                          mapCubit.userLocation = location;
                          await mapCubit.cameraMoveEnded(
                              await _controller.getVisibleRegion(), await _controller.getZoomLevel(), _controller);
                        },
                        onTap: (v) {
                          _focusNode.unfocus();
                        },
                        onCameraMove: (position) {
                          _focusNode.unfocus();
                          context.read<MapCubit>().center = Utils.gmapsLatLngToLatLng2(position.target);
                          //context.read<MapCubit>().zoomInZoomOut();
                        },
                        onCameraIdle: () async => await context.read<MapCubit>().cameraMoveEnded(
                            await _controller.getVisibleRegion(), await _controller.getZoomLevel(), _controller),
                        buildingsEnabled: false,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(location.latitude, location.longitude),
                          zoom: 15,
                        ),
                        markers: context.read<MapCubit>().searchByCityOn
                            ? context.read<MapCubit>().cityMarkers
                            : context.read<MapCubit>().normalMarker,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 80,
                    right: 16,
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton.small(
                          onPressed: _currentLocation,
                          backgroundColor: Colors.white.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Color(0xffc6c6c6)),
                              borderRadius: BorderRadius.circular(60)),
                          child: const Icon(CupertinoIcons.location_fill, size: 20),
                        ),
                      ),
                    ),
                  ),
                  context.read<MapCubit>().searchByCityOn
                      ? const SizedBox()
                      : Positioned(
                          top: 64,
                          child: SafeArea(
                            child: BlocBuilder<MapCubit, MapState>(
                              buildWhen: (previous, current) => current is ShowSearchButton,
                              builder: (context, state) {
                                if (state is ShowSearchButton && state.show) {
                                  return const SearchThisAreaButton();
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                  context.read<MapCubit>().searchByCityOn
                      ? Positioned(
                          top: 16,
                          child: SafeArea(
                            child: AllCountrySearch(
                              focusNode: _focusNode,
                              googleMapController: _controller,
                            ),
                          ),
                        )
                      : Positioned(
                          top: 16,
                          child: SafeArea(
                            child: MapSearch(
                                focusNode: _focusNode, userLocation: location, countryCode: locationCubit.countryCode),
                          ),
                        ),
                  const Positioned(
                    bottom: 70,
                    child: Align(
                        alignment: Alignment.center, child: SizedBox(width: 350, height: 70, child: GoogleAdBanners())),
                  ),
                ],
              ),
              Positioned(
                bottom: 125,
                right: 16,
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.small(
                        onPressed: () {
                          context.read<MapCubit>().searchByCityMethod();
                        },
                        backgroundColor: Colors.white.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xffc6c6c6)), borderRadius: BorderRadius.circular(60)),
                        child: context.read<MapCubit>().searchByCityOn
                            ? const Icon(CupertinoIcons.reply_all, size: 20)
                            : const Icon(CupertinoIcons.globe, size: 20)),
                  ),
                ),
              ),
              context.read<MapCubit>().loading
                  ? const Align(alignment: Alignment.center, child: SizedBox(child: CircularProgressIndicator()))
                  : const SizedBox(),
            ],
          ),
        );
      });
    });
  }

  void _currentLocation() async {
    final lat_lng2.LatLng currentLocation = context.read<LocationCubit>().location;

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 15.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
