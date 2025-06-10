import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart';
import 'package:parki_dog/core/navigation/cubit/navigation_cubit.dart';
import 'package:parki_dog/core/services/gmaps/gmaps_service.dart';
import 'package:parki_dog/core/utils.dart';
import 'package:parki_dog/features/home/data/home_local_repository.dart';
import 'package:parki_dog/features/home/data/home_remote_repository.dart';
import 'package:parki_dog/features/home/data/park_model.dart';
import 'package:parki_dog/features/map/view/widgets/map_marker.dart';
import 'package:parki_dog/features/map/view/widgets/single_city_park_screen.dart';
import 'package:parki_dog/features/park/view/pages/park_screen.dart';
import 'package:parki_dog/main.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:flutter/material.dart';

import '../../home/data/city_parks_model.dart';
import '../../park/data/prediction_model.dart';
import '../../park/data/single_park_model.dart';
import '../view/widgets/checked_marker.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit(this._navigationCubit) : super(MapInitial());

  late final NavigationCubit _navigationCubit;

  late final LatLng userLocation;

  LatLng center = const LatLng(0, 0);
  LatLng _prevCenter = const LatLng(0, 0);

  int _searchRadius = 1500;
  int _previousRadius = 0;

  double _zoom = 0;
  double _previousZoom = 0;

  List<ParkModel> _parks = [];

  Future<void> cameraMoveEnded(gmaps.LatLngBounds bounds, double zoom,
      gmaps.GoogleMapController googleMapController) async {
    _searchRadius = Utils.getRadiusFromBounds(bounds);
    if (zoom > 13.5 && _zoom < 13.5 || zoom < 13.5 && _zoom > 13.5) {
      _zoom = zoom;
      getMarkers(_parks);
      if (cityMarkers.isNotEmpty) zoomInZoomOut();
    } else {
      _zoom = zoom;
    }

    hasViewChanged();
  }

  Future<void> getMapNearbyParks() async {
    if (!hasViewChanged()) return;

    final localParks = await getNearbyParksFromDB(
        center, _searchRadius < 500 ? 500 : _searchRadius);

    final thresh = 19 - _zoom.round() > 0 ? 19 - _zoom.round() : 0;

    if (localParks.length >= thresh) {
      _parks = localParks;
      await getMarkers(localParks);
      _onNearbySearchComplete();
      return;
    }

    final response = await GMapsService.nearbySearch('dog park', 'park', center,
        radius: _searchRadius < 500 ? 500 : _searchRadius);
    return response.fold(
      (l) => emit(MapError(l)),
      (r) async {
        List<ParkModel> parks = await Future.wait(
          r.map(
            (park) async {
              HomeLocalRepository.savePark(ParkModel.fromGMaps(park));
              var parkModel = ParkModel.fromGMaps(park);
              parkModel.numberOfDogs =
                  await getNumberOfCheckedInDogs(parkModel.id!);

              return parkModel;
            },
          ).cast<Future<ParkModel>>(), // Explicitly cast to Future<ParkModel>
        );

        _parks = parks;
        await getMarkers(parks);
        emit(MapParksLoaded(parks));
        _onNearbySearchComplete();
      },
    );
  }

  void _onNearbySearchComplete() {
    _prevCenter = center;
    _previousZoom = _zoom;
    _previousRadius = _searchRadius;
    emit(const ShowSearchButton(false));
  }

  bool hasViewChanged() {
    final distance = Utils.getDistance(center, _prevCenter);
    final zoomDifference = (_zoom - _previousZoom).abs();

    if (distance > _previousRadius || zoomDifference > 1) {
      emit(const ShowSearchButton(true));
      return true;
    }

    emit(const ShowSearchButton(false));
    return false;
  }

  List<dynamic> holdMarkerCheckIn = [];
  Set<gmaps.Marker> normalMarker = {};
  Future<void> getMarkers(List<ParkModel> parks) async {
    List<gmaps.Marker> markers =
        await Future.wait(parks.map<Future<gmaps.Marker>>(
      (park) async {
        final marker = gmaps.Marker(
          onTap: () async {
            emit(StartBuildingPark());
            loading = true;
            holdMarkerCheckIn = [
              park.name!,
              park.numberOfDogs,
            ];
            await parkDetails(parkId: park.id!)
                .whenComplete(() async => await getAllParkImage())
                .whenComplete(
                  () => Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(
                        builder: (context) => ParkScreen(
                          () async {
                            park.photoUrl ??= await GMapsService.getPlacePhoto(
                                park.photoReference);
                            return park;
                          },
                          result: singleParkModel!.result!,
                          parkImageList: parkImageList,
                          checkIn: () async => await checkInPark(
                              position: gmaps.LatLng(park.location!.latitude,
                                  park.location!.longitude)),
                          checkOut: () async => await checkOutPark(
                            position: gmaps.LatLng(park.location!.latitude,
                                park.location!.longitude),
                          ),
                        ),
                      )),
                );
            loading = false;
            emit(EndBuildingPark());
          },
          markerId: gmaps.MarkerId(park.id!),
          position:
              gmaps.LatLng(park.location!.latitude, park.location!.longitude),
          icon: checkPark == park.id!
              ? await CheckedMapMarker(
                  name: park.name!,
                  numberOfDogs: park.numberOfDogs,
                  zoom: _zoom,
                ).toBitmapDescriptor()
              : await MapMarker(
                  name: park.name!,
                  numberOfDogs: park.numberOfDogs,
                  zoom: _zoom,
                ).toBitmapDescriptor(),
        );

        return marker;
      },
    ).toList());
    if (checkMarker != null) {
      bool markerThere = false;
      for (var i in markers) {
        if (i.markerId.value == checkMarker?.markerId.value) {
          int numberOfDogs =
              await getNumberOfCheckedInDogs(checkMarker!.markerId.value);
          markers.remove(i);
          markers.add(gmaps.Marker(
              onTap: checkMarker!.onTap,
              markerId: checkMarker!.markerId,
              position: checkMarker!.position,
              icon: await CheckedMapMarker(
                name: checkMarkerName!,
                numberOfDogs: numberOfDogs,
                zoom: _zoom,
              ).toBitmapDescriptor()));
          markerThere = true;
        }
      }
      if (markerThere == false) {
        int numberOfDogs =
            await getNumberOfCheckedInDogs(checkMarker!.markerId.value);
        markers.add(gmaps.Marker(
            onTap: checkMarker!.onTap,
            markerId: checkMarker!.markerId,
            position: checkMarker!.position,
            icon: await CheckedMapMarker(
              name: checkMarkerName!,
              numberOfDogs: numberOfDogs,
              zoom: _zoom,
            ).toBitmapDescriptor()));
      }
    }
    normalMarker = {...markers};
    emit(MarkersLoaded({...markers}));
  }

  String checkPark = 'zz';
  gmaps.Marker? checkMarker;
  String? checkMarkerName;
  Future<void> checkInHomePark(
      {required String iD, required SingleParkModel singleParkModel}) async {
    int numberOfDogs = await getNumberOfCheckedInDogs(iD);
    if (normalMarker.isNotEmpty) {
      gmaps.Marker newMarker =
          normalMarker.singleWhere((e) => e.markerId.value == iD);
      checkPark = newMarker.markerId.value;
      normalMarker.removeWhere((e) => e.markerId.value == iD);
      normalMarker.add(gmaps.Marker(
          onTap: newMarker.onTap,
          markerId: newMarker.markerId,
          position: newMarker.position,
          icon: await CheckedMapMarker(
            name: holdMarkerCheckIn[0],
            numberOfDogs: numberOfDogs,
            zoom: _zoom,
          ).toBitmapDescriptor()));
      checkMarker = gmaps.Marker(
          onTap: newMarker.onTap,
          markerId: newMarker.markerId,
          position: newMarker.position,
          icon: await CheckedMapMarker(
            name: holdMarkerCheckIn[0],
            numberOfDogs: numberOfDogs,
            zoom: _zoom,
          ).toBitmapDescriptor());
      checkMarkerName = holdMarkerCheckIn[0];
    } else {
      //   await parkDetails(parkId: iD);
      checkPark = singleParkModel.result?.placeId ?? 'homeMarker';
      normalMarker.add(gmaps.Marker(
        onTap: () async {
          emit(StartBuildingPark());
          loading = true;
          holdMarkerCheckIn = [
            singleParkModel.result?.name!,
            numberOfDogs,
          ];
          await parkDetails(parkId: singleParkModel.result!.placeId!)
              .whenComplete(() async => await getAllParkImage())
              .whenComplete(() => _navigationCubit.showBottomSheet(
                    ParkScreen(() async {
                      return ParkModel(
                        name: singleParkModel.result!.name,
                        id: singleParkModel.result!.placeId,
                        location: GeoPoint(
                            singleParkModel.result!.geometry!.location!.lat!,
                            singleParkModel.result!.geometry!.location!.lng!),
                        numberOfDogs: numberOfDogs,
                        photoUrl: '',
                        photoReference: '',
                        userRatingsTotal:
                            singleParkModel.result!.userRatingsTotal,
                        rating: singleParkModel.result!.rating?.toDouble(),
                      );
                    },
                        result: singleParkModel.result!,
                        parkImageList: parkImageList,
                        checkIn: () async => await checkInPark(
                            position: gmaps.LatLng(
                                singleParkModel
                                    .result!.geometry!.location!.lat!,
                                singleParkModel
                                    .result!.geometry!.location!.lng!)),
                        checkOut: () async => await checkOutPark(
                            position: gmaps.LatLng(
                                singleParkModel
                                    .result!.geometry!.location!.lat!,
                                singleParkModel
                                    .result!.geometry!.location!.lng!))),
                  ));

          loading = false;
          emit(EndBuildingPark());
        },
        markerId:
            gmaps.MarkerId(singleParkModel.result?.placeId ?? 'homeMarker'),
        position: gmaps.LatLng(
            singleParkModel.result?.geometry?.location?.lat ?? 0,
            singleParkModel.result?.geometry?.location?.lng ?? 0),
        icon: await CheckedMapMarker(
          name: singleParkModel.result!.name!,
          zoom: _zoom,
        ).toBitmapDescriptor(),
      ));
      checkMarker = gmaps.Marker(
        onTap: () async {
          emit(StartBuildingPark());
          loading = true;
          holdMarkerCheckIn = [
            singleParkModel.result?.name!,
            numberOfDogs,
          ];
          await parkDetails(parkId: singleParkModel.result!.placeId!)
              .whenComplete(() async => await getAllParkImage())
              .whenComplete(() => _navigationCubit.showBottomSheet(
                    ParkScreen(() async {
                      return ParkModel(
                        name: singleParkModel.result!.name,
                        id: singleParkModel.result!.placeId,
                        location: GeoPoint(
                            singleParkModel.result!.geometry!.location!.lat!,
                            singleParkModel.result!.geometry!.location!.lng!),
                        numberOfDogs: numberOfDogs,
                        photoUrl: '',
                        photoReference: '',
                        userRatingsTotal:
                            singleParkModel.result!.userRatingsTotal,
                        rating: singleParkModel.result!.rating?.toDouble(),
                      );
                    },
                        result: singleParkModel.result!,
                        parkImageList: parkImageList,
                        checkIn: () async => await checkInPark(
                            position: gmaps.LatLng(
                                singleParkModel
                                    .result!.geometry!.location!.lat!,
                                singleParkModel
                                    .result!.geometry!.location!.lng!)),
                        checkOut: () async => await checkOutPark(
                            position: gmaps.LatLng(
                                singleParkModel
                                    .result!.geometry!.location!.lat!,
                                singleParkModel
                                    .result!.geometry!.location!.lng!))),
                  ));

          loading = false;
          emit(EndBuildingPark());
        },
        markerId:
            gmaps.MarkerId(singleParkModel.result?.placeId ?? 'homeMarker'),
        position: gmaps.LatLng(
            singleParkModel.result?.geometry?.location?.lat ?? 0,
            singleParkModel.result?.geometry?.location?.lng ?? 0),
        icon: await CheckedMapMarker(
          name: singleParkModel.result!.name!,
          zoom: _zoom,
        ).toBitmapDescriptor(),
      );
      checkMarkerName = singleParkModel.result?.name!;
    }
    emit(CheckedInPark());
    emit(EndOfMethodState());
  }

  Future<void> checkInPark({required gmaps.LatLng position}) async {
    gmaps.Marker newMarker =
        normalMarker.singleWhere((e) => e.position == position);
    checkPark = newMarker.markerId.value;
    int numberOfDogs = await getNumberOfCheckedInDogs(newMarker.markerId.value);
    normalMarker.removeWhere((e) => e.position == position);
    normalMarker.add(gmaps.Marker(
        onTap: newMarker.onTap,
        markerId: newMarker.markerId,
        position: newMarker.position,
        icon: await CheckedMapMarker(
          name: holdMarkerCheckIn[0],
          numberOfDogs: numberOfDogs,
          zoom: _zoom,
        ).toBitmapDescriptor()));

    emit(CheckedInPark());
    emit(EndOfMethodState());
    showSuccessDialog();
  }

  void showSuccessDialog() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        Future.delayed(const Duration(seconds: 2), () {
          if (navigatorKey.currentState?.canPop() ?? false) {
            navigatorKey.currentState?.pop();
          }
        });

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Checked-in Successfully!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkOutPark({required gmaps.LatLng position}) async {
    checkPark = 'zz';
    gmaps.Marker newMarker =
        normalMarker.singleWhere((e) => e.position == position);
    int numberOfDogs = await getNumberOfCheckedInDogs(newMarker.markerId.value);
    normalMarker.removeWhere((e) => e.position == position);
    normalMarker.add(gmaps.Marker(
        onTap: newMarker.onTap,
        markerId: newMarker.markerId,
        position: newMarker.position,
        icon: await MapMarker(
          name: holdMarkerCheckIn[0],
          numberOfDogs: numberOfDogs,
          zoom: _zoom,
        ).toBitmapDescriptor()));
    checkMarker = null;
    checkMarkerName = null;
    emit(CheckedOutPark());
    emit(EndOfMethodState());
  }

  Future<void> checkOutGlob({required gmaps.LatLng position}) async {
    try {
      gmaps.Marker newMarker =
          cityMarkers.singleWhere((e) => e.position == position);
      int numberOfDogs =
          await getNumberOfCheckedInDogs(newMarker.markerId.value);
      cityMarkers.removeWhere((e) => e.position == position);
      cityMarkers.add(gmaps.Marker(
          onTap: newMarker.onTap,
          markerId: newMarker.markerId,
          position: newMarker.position,
          icon: await MapMarker(
            name: holdMarkerCheckIn[0],
            numberOfDogs: numberOfDogs,
            zoom: _zoom,
          ).toBitmapDescriptor()));
      checkPark = 'zz';
      checkMarker = null;
      checkMarkerName = null;
    } catch (e) {
      print(e);
    }
    try {
      gmaps.Marker newMarker =
          cityMarkers.singleWhere((e) => e.markerId.value == checkPark);
      int numberOfDogs =
          await getNumberOfCheckedInDogs(newMarker.markerId.value);
      cityMarkers.removeWhere((e) => e.markerId.value == checkPark);
      cityMarkers.add(gmaps.Marker(
          onTap: newMarker.onTap,
          markerId: newMarker.markerId,
          position: newMarker.position,
          icon: await MapMarker(
            name: holdMarkerCheckIn[0],
            numberOfDogs: numberOfDogs,
            zoom: _zoom,
          ).toBitmapDescriptor()));
      checkPark = 'zz';
      checkMarker = null;
      checkMarkerName = null;
    } catch (e) {
      print('errror2');
    }
    emit(CheckedOutPark());
    emit(EndOfMethodState());
  }

  Future<void> checkInGlob({required gmaps.LatLng position}) async {
    gmaps.Marker newMarker =
        cityMarkers.singleWhere((e) => e.position == position);
    checkPark = newMarker.markerId.value;
    int numberOfDogs = await getNumberOfCheckedInDogs(newMarker.markerId.value);
    cityMarkers.removeWhere((e) => e.position == position);
    cityMarkers.add(gmaps.Marker(
        onTap: newMarker.onTap,
        markerId: newMarker.markerId,
        position: newMarker.position,
        icon: await CheckedMapMarker(
          name: holdMarkerCheckIn[0],
          numberOfDogs: numberOfDogs,
          zoom: _zoom,
        ).toBitmapDescriptor()));

    emit(CheckedInPark());
    emit(EndOfMethodState());
  }

  Future<void> checkOutAll({required String iD}) async {
    try {
      int numberOfDogs = await getNumberOfCheckedInDogs(iD);
      gmaps.Marker newMarker = normalMarker
          .singleWhere((e) => e.markerId.value == gmaps.MarkerId(iD).value);
      normalMarker
          .removeWhere((e) => e.markerId.value == gmaps.MarkerId(iD).value);
      normalMarker.add(gmaps.Marker(
          onTap: newMarker.onTap,
          markerId: newMarker.markerId,
          position: newMarker.position,
          icon: await MapMarker(
            name: holdMarkerCheckIn[0],
            numberOfDogs: numberOfDogs,
            zoom: _zoom,
          ).toBitmapDescriptor()));
      checkPark = 'zz';
      checkMarker = null;
      checkMarkerName = null;
      emit(CheckedOutPark());
    } catch (e) {}
    try {
      int numberOfDogs = await getNumberOfCheckedInDogs(iD);
      gmaps.Marker newMarker = cityMarkers
          .singleWhere((e) => e.markerId.value == gmaps.MarkerId(iD).value);
      cityMarkers
          .removeWhere((e) => e.markerId.value == gmaps.MarkerId(iD).value);
      cityMarkers.add(gmaps.Marker(
          onTap: newMarker.onTap,
          markerId: newMarker.markerId,
          position: newMarker.position,
          icon: await MapMarker(
            name: holdMarkerCheckIn[0],
            numberOfDogs: numberOfDogs,
            zoom: _zoom,
          ).toBitmapDescriptor()));
      checkPark = 'zz';
      emit(CheckedOutPark());
      checkMarker = null;
      checkMarkerName = null;
    } catch (e) {}
    emit(CheckedOutPark());
    emit(EndOfMethodState());
  }

  Future<List<ParkModel>> getNearbyParksFromDB(
      LatLng location, int radius) async {
    var parks = HomeLocalRepository.getNearbyParks(location, radius);

    await Future.wait(parks.map((e) async {
      e.numberOfDogs = await getNumberOfCheckedInDogs(e.id!);
    }).toList());

    return parks;
  }

  Future<void> parkTextSearch(
    String text,
    LatLng location,
    String countryCode,
  ) async {
    if (!validateSearchText(text)) {
      emit(const AutocompleteResults([]));
      return;
    }

    EasyThrottle.throttle(
      'place-autocomplete',
      const Duration(milliseconds: 500),
      () async {
        try {
          final response = await GMapsService.autocomplete(
              text, location, countryCode, Utils.sessionToken);

          return response.fold(
            (l) => emit(MapError(l)),
            (r) async {
              List<ParkModel> parks = r
                  .map(
                    (result) => ParkModel(
                      id: result['place_id'],
                      name: result['structured_formatting']['main_text'],
                    ),
                  )
                  .toList();

              emit(AutocompleteResults(parks));
            },
          );
        } catch (e) {
          return;
        }
      },
    );
  }

  Future<void> getSelectedPark(String id) async {
    await parkDetails(parkId: id)
        .whenComplete(() async => await getAllParkImage())
        .whenComplete(() => _navigationCubit.showBottomSheet(
              ParkScreen(
                () async {
                  final response = await GMapsService.getPlaceDetails(
                      id, Utils.sessionToken);
                  return response.fold(
                    (l) => emit(MapError(l)),
                    (result) async {
                      Utils.regenerateSessionToken();
                      final park =
                          ParkModel.fromGMaps(result as Map<String, dynamic>);
                      park.photoUrl =
                          await GMapsService.getPlacePhoto(park.photoReference);
                      return park;
                    },
                  );
                },
                result: singleParkModel!.result!,
                parkImageList: parkImageList,
              ),
            ));
  }

  Future<int> getNumberOfCheckedInDogs(String id) async {
    final response = await HomeRemoteRepository.getNumberOfDogs(id);

    return response.fold(
      (l) {
        emit(MapError(l));
        return 0;
      },
      (r) => r,
    );
  }

  bool validateSearchText(String text) {
    return text.length > 3;
  }

  bool searchByCityOn = false;
  searchByCityMethod() {
    emit(SearchByCountryOffState());
    searchByCityOn = !searchByCityOn;
    emit(SearchByCountryOnState());
  }

  Future<void> cityTextSearch(
    String text,
  ) async {
    if (!validateSearchText(text)) {
      emit(const CityAutocompleteResults([]));
      return;
    }
    EasyThrottle.throttle(
      'city-autocomplete',
      const Duration(milliseconds: 500),
      () async {
        try {
          final response = await GMapsService.cityAutocomplete(text);
          return response.fold(
            (l) => emit(MapError(l)),
            (r) async {
              PredictionsModel predictionsModel =
                  PredictionsModel.fromJson(r as Map<String, dynamic>);
              emit(CityAutocompleteResults(predictionsModel.predictions!));
            },
          );
        } catch (e) {
          return;
        }
      },
    );
  }

  ParksModel? parksModel;
  getAllParksInCity(
      {required BuildContext context,
      required String city,
      required gmaps.GoogleMapController googleMapController}) {
    if (!validateSearchText(city)) {
      return;
    }
    EasyThrottle.throttle(
      'city-all-parks',
      const Duration(seconds: 2),
      () async {
        try {
          final response = await GMapsService.searchParksInCity(city);
          return response.fold(
            (l) => emit(MapError(l)),
            (r) async {
              parksModel = ParksModel.fromJson(r as Map<String, dynamic>);
              getCityParksMarker(googleMapController);
              parkDetails(parkId: parksModel!.results![0].placeId!);
            },
          );
        } catch (e) {
          return;
        }
      },
    );
    // changeMapCenterCamera(googleMapController);
  }

  zoomInZoomOut() async {
    cityMarkers = {};
    for (var i in parksModel!.results!) {
      gmaps.BitmapDescriptor x;
      int numberOfDogs = await getNumberOfCheckedInDogs(i.placeId!);
      if (checkPark == gmaps.MarkerId(i.placeId!).value) {
        x = await CheckedMapMarker(
          numberOfDogs: numberOfDogs,
          name: i.name!,
          zoom: _zoom,
        ).toBitmapDescriptor();
      } else {
        x = await MapMarker(
          numberOfDogs: numberOfDogs,
          name: i.name!,
          zoom: _zoom,
        ).toBitmapDescriptor();
      }
      cityMarkers.add(
        gmaps.Marker(
          markerId: gmaps.MarkerId(i.placeId!),
          icon: x,
          onTap: () async {
            emit(StartBuildingPark());
            loading = true;
            holdMarkerCheckIn = [
              i.name!,
              numberOfDogs,
            ];
            await parkDetails(parkId: i.placeId!)
                .whenComplete(() async => await getAllParkImage())
                .whenComplete(() {
              if (calculateDistance(
                      userLocation.latitude,
                      userLocation.longitude,
                      i.geometry!.location!.lat!,
                      i.geometry!.location!.lng!) >
                  1500) {
                _navigationCubit.showBottomSheet(
                  SingleCityPark(
                    result: singleParkModel!.result!,
                    parkImageList: parkImageList,
                  ),
                );
              } else {
                _navigationCubit.showBottomSheet(
                  ParkScreen(() async {
                    return ParkModel(
                      name: i.name,
                      id: i.placeId,
                      location: GeoPoint(i.geometry!.location!.lat!,
                          i.geometry!.location!.lng!),
                      numberOfDogs: numberOfDogs,
                      photoUrl: '',
                      photoReference: '',
                      userRatingsTotal: i.userRatingsTotal,
                      rating: i.rating?.toDouble(),
                    );
                  },
                      result: singleParkModel!.result!,
                      parkImageList: parkImageList,
                      checkIn: () async => await checkInGlob(
                          position: gmaps.LatLng(i.geometry!.location!.lat!,
                              i.geometry!.location!.lng!)),
                      checkOut: () async => await checkOutGlob(
                          position: gmaps.LatLng(i.geometry!.location!.lat!,
                              i.geometry!.location!.lng!))),
                );
              }
            });

            loading = false;
            emit(EndBuildingPark());
          },
          position: gmaps.LatLng(
              i.geometry!.location!.lat!, i.geometry!.location!.lng!),
        ),
      );
    }
    emit(CityMarkersLoaded({...cityMarkers}));
  }

  bool loading = false;
  Set<gmaps.Marker> cityMarkers = {};
  getCityParksMarker(gmaps.GoogleMapController googleMapController) async {
    if (parksModel == null || parksModel?.results == null) {
      return;
    }
    cityMarkers = {};
    for (var i in parksModel!.results!) {
      emit(ParkByParkState());
      int numberOfDogs = await getNumberOfCheckedInDogs(i.placeId!);
      cityMarkers.add(
        gmaps.Marker(
          markerId: gmaps.MarkerId(i.placeId!),
          icon: checkPark == gmaps.MarkerId(i.placeId!).value
              ? await CheckedMapMarker(
                  name: i.name!,
                  zoom: _zoom,
                ).toBitmapDescriptor()
              : await MapMarker(
                  name: i.name!,
                  zoom: _zoom,
                ).toBitmapDescriptor(),
          onTap: () async {
            emit(StartBuildingPark());
            loading = true;
            holdMarkerCheckIn = [
              i.name!,
              numberOfDogs,
            ];
            await parkDetails(parkId: i.placeId!)
                .whenComplete(() async => await getAllParkImage())
                .whenComplete(() async {
              if (calculateDistance(
                      userLocation.latitude,
                      userLocation.longitude,
                      i.geometry!.location!.lat!,
                      i.geometry!.location!.lng!) >
                  1500) {
                _navigationCubit.showBottomSheet(
                  SingleCityPark(
                    result: singleParkModel!.result!,
                    parkImageList: parkImageList,
                  ),
                );
              } else {
                int numberOfDogs = await getNumberOfCheckedInDogs(i.placeId!);
                _navigationCubit.showBottomSheet(
                  ParkScreen(() async {
                    return ParkModel(
                      name: i.name,
                      id: i.placeId,
                      location: GeoPoint(i.geometry!.location!.lat!,
                          i.geometry!.location!.lng!),
                      numberOfDogs: numberOfDogs,
                      photoUrl: '',
                      photoReference: '',
                      userRatingsTotal: i.userRatingsTotal,
                      rating: i.rating?.toDouble(),
                    );
                  },
                      result: singleParkModel!.result!,
                      parkImageList: parkImageList,
                      checkIn: () async => await checkInGlob(
                          position: gmaps.LatLng(i.geometry!.location!.lat!,
                              i.geometry!.location!.lng!)),
                      checkOut: () async => await checkOutGlob(
                          position: gmaps.LatLng(i.geometry!.location!.lat!,
                              i.geometry!.location!.lng!))),
                );
              }
            });

            loading = false;
            emit(EndBuildingPark());
          },
          position: gmaps.LatLng(
              i.geometry!.location!.lat!, i.geometry!.location!.lng!),
        ),
      );
      emit(GotMarkerMapState());
      if (i == parksModel!.results![0]) {
        googleMapController.animateCamera(
          gmaps.CameraUpdate.newCameraPosition(
            gmaps.CameraPosition(
              bearing: 0,
              target: gmaps.LatLng(
                  i.geometry!.location!.lat!, i.geometry!.location!.lng!),
              zoom: _zoom,
            ),
          ),
        );
      }
    }
    emit(CityMarkersLoaded({...cityMarkers}));
  }

  late SingleParkModel? singleParkModel;
  Future parkDetails({required String parkId}) async {
    Completer<void> completer = Completer<void>();
    singleParkModel = null;
    EasyThrottle.throttle(
      'city-single-parks',
      const Duration(seconds: 2),
      () async {
        try {
          final response = await GMapsService.getPlaceDetailsFromCity(parkId);
          return response.fold(
            (l) => emit(MapError(l)),
            (r) async {
              singleParkModel =
                  SingleParkModel.fromJson(r as Map<String, dynamic>);
              completer.complete();
            },
          );
        } catch (e) {
          completer.completeError(e);
        }
      },
    );
    emit(SingleParkState());
    return completer.future;
  }

  List<String> parkImageList = [];
  getAllParkImage() async {
    if (singleParkModel?.result?.photos == null) return;
    parkImageList = [];
    int x = 0;
    for (var i in singleParkModel!.result!.photos!) {
      if (x == 3) return;
      var photo = await GMapsService.getPlacePhoto(i.photoReference);
      parkImageList.add(photo!);
      x = x + 1;
    }
    emit(GetAllPhotosState());
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0; // Earth radius in meters
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}
