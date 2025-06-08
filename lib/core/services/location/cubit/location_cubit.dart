import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  LatLng _location = const LatLng(41.90336003555587, 12.495883354581201);
  LatLng get location => _location;

  String _countryCode = '';
  String get countryCode => _countryCode;

  /// /// //
  Future<void> getLocation() async {
    await requestPermission();

    try {
      final position = await Geolocator.getCurrentPosition();
      _location = LatLng(position.latitude, position.longitude);
      _countryCode = await getCountryCode(_location);
    } catch (e) {
      getLastKnownLocation();
    }

    emit(LocationLoaded(_location));
  }

  Future<void> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        _location = LatLng(position.latitude, position.longitude);
        _countryCode = await getCountryCode(_location);
      }
    } catch (e) {
      // emit(LocationError());
    }
  }

  static Future<String> getCountryCode(LatLng location) async {
    try {
      final address = await placemarkFromCoordinates(location.latitude, location.longitude);
      return address.first.isoCountryCode?.toLowerCase() ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<void> requestPermission() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
  }
}
