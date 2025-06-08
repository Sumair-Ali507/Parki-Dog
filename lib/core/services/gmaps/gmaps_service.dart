import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:parki_dog/core/services/networking/networking.dart';

class GMapsService {
  static const String _gmapsKey = 'AIzaSyCzQ_kDgzaCZoSThNJ8I-qJc0fj2yD9TT0';

  static Future<Either<String, Map>> findPlace(String place, GeoPoint location) async {
    try {
      final response = await NetworkService.getApiResponse(
          'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?&language=en&input=$place&inputtype=textquery&fields=name,rating,user_ratings_total,photos&locationbias=circle:5@${location.latitude},${location.longitude}&key=$_gmapsKey');

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future nearbySearch(String keyword, String type, LatLng location, {int radius = 1500}) async {
    try {
      final response = await NetworkService.getApiResponse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&keyword=$keyword&location=${location.latitude},${location.longitude}&radius=$radius&type=$type&key=$_gmapsKey');
      return Right(response['results']);
      //! NEW PLACES API ATTEMPT
      // final response = await NetworkService.postApiResponse(
      //   'https://places.googleapis.com/v1/places:searchNearby',
      //   {
      //     'includedTypes': ['dog_park'],
      //     'maxResultCount': 10,
      //     'locationRestriction': {
      //       'circle': {
      //         'center': {
      //           'latitude': location.latitude,
      //           'longitude': location.longitude
      //         },
      //         'radius': radius
      //       }
      //     }
      //   },
      //   {
      //     'Content-Type': 'application/json',
      //     'X-Goog-Api-Key': _gmapsKey,
      //     'X-Goog-FieldMask':
      //         'places.id,places.displayName,places.location,places.photos,places.rating,places.userRatingCount',
      //   },
      // );

      // return Right(response['places']);
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  static Future<String?> getPlacePhoto(String? photoReference) async {
    if (photoReference == null) return null;

    try {
      final response = await NetworkService.getImageApiResponse(
        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photo_reference=$photoReference&key=$_gmapsKey',
      );

      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<Either<String, List>> autocomplete(
    String input,
    LatLng location,
    String countryCode,
    String sessionToken,
  ) async {
    try {
      final response = await NetworkService.getApiResponse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&location=${location.latitude},${location.longitude}&radius=20000&types=park&components=country:$countryCode&sessiontoken=$sessionToken&key=$_gmapsKey');

      return Right(response['predictions']);
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, Map>> cityAutocomplete(
    String input,
  ) async {
    try {
      final response = await NetworkService.getApiResponse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&fields=name&key=$_gmapsKey');

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // get place details
  static Future<Either<String, Map>> getPlaceDetails(String placeId, String sessionToken) async {
    try {
      final response = await NetworkService.getApiResponse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=place_id,name,geometry,photo,rating,user_ratings_total&sessiontoken=$sessionToken&key=$_gmapsKey&language=${'lang'.tr()}');
      return Right(response['result']);
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, Map>> searchParksInCity(String cityName) async {
    try {
      final response = await NetworkService.getApiResponse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=dog park+in+$cityName&fields=name,rating,user_ratings_total,photos,geometry,reviews&types=park&key=$_gmapsKey&language=${'lang'.tr()}');
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, Map>> getPlaceDetailsFromCity(String placeId) async {
    try {
      final response = await NetworkService.getApiResponse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=place_id,name,geometry,photo,rating,user_ratings_total,review,url&key=$_gmapsKey&language=${'lang'.tr()}');
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
