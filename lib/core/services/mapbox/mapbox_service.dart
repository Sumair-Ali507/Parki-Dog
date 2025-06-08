import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:parki_dog/core/services/networking/networking.dart';

class MapboxService {
  static const String _mapboxToken =
      'pk.eyJ1IjoicGFya2ktZG9nIiwiYSI6ImNsbTBrZWk4dTB2NTMzcW4xbTJ1NGZ1amcifQ.81vHgwnxrwE-n6WT1DoKbQ';

  // static const String _baseUrl =
  //     'https://maps.googleapis.com/maps/api/place/nearbysearch/json?';

  static Future<Either<String, Map>> searchPlaces(LatLng location) async {
    try {
      final response = await NetworkService.getApiResponse(
          'https://api.mapbox.com/search/searchbox/v1/category/dog_park?access_token=$_mapboxToken&limit=5&proximity=${location.longitude},${location.latitude}');

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
