import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/services/hive/hive.dart';
import 'package:parki_dog/features/auth/data/auth_repository.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/data/unsocial_with_model.dart';
import 'package:parki_dog/features/park/data/single_park_model.dart';

import '../../../core/services/gmaps/gmaps_service.dart';
import '../../map/cubit/map_cubit.dart';

class ParkRepository {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<Either<String, List<DogModel>>> getParkData(String id) async {
    try {
      final result = await _db.collection('parks/$id/$id').get();

      List<DogModel> dogs = [];

      await Future.wait(result.docs.map(
        (dogRaw) async {
          final dog = await AuthRepository.getDog(dogRaw.id);

          return dog.fold(
            (error) => left(error),
            (dog) {
              if (dog != null) {
                dogs.add(dog);
              }
            },
          );
        },
      ).toList());

      return right(dogs);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> checkInDog(
      String parkId, String parkName, String dogId, DateTime leaveTime) async {
    final isoTime = leaveTime.toUtc();
    try {
      final isCheckedIn = await isAlreadyCheckedIn(dogId);

      if (isCheckedIn == null) return left('Something went wrong');
      if (isCheckedIn == true) return left('Dog is already checked in');

      await _db.doc('parks/$parkId').set({'notificationSubscribers': []});

      await _db.doc('parks/$parkId/$parkId/$dogId').set({
        'leaveTime': isoTime,
        'checkoutTask': null,
      });

      await _db.doc('dogs/$dogId').update({
        'currentCheckIn': {
          'parkId': parkId,
          'parkName': parkName,
          'leaveTime': isoTime,
        },
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<bool?> isAlreadyCheckedIn(String dogId) async {
    try {
      final result = await _db.doc('dogs/$dogId').get();

      return result.data()?['currentCheckIn'] != null;
    } catch (e) {
      return null;
    }
  }

  static Future<Either<String, void>> checkOutDog(String dogId, String parkId) async {
    try {
      await _db.doc('parks/$parkId/$parkId/$dogId').delete();
      await _db.doc('dogs/$dogId').update({
        'currentCheckIn': null,
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> subscribeToNotifications(String parkId, UnsocialWithModel unsocialWith) async {
    try {
      //final token = await FirebaseMessaging.instance.getToken();
      final token = HiveStorageService.readData(key: 'userToken');
      await _db.doc('parks/$parkId').update({
        'notificationSubscribers': FieldValue.arrayUnion(
          [
            {
              'unsocialWith': unsocialWith.toMap(),
              'notificationToken': token,
            }
          ],
        ),
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, String>> getNotificationToken(String dogId) async {
    try {
      final result = await _db.doc('dogs/$dogId').get();

      final token = result.data()?['notificationToken'];

      if (token == null) {
        return left('No token found');
      }

      return right(token);
    } catch (e) {
      return left(e.toString());
    }
  }

  static SingleParkModel? singleParkModel;
  static Future parkDetails({required String parkId}) async {
    Completer<void> completer = Completer<void>();
    EasyThrottle.throttle(
      'city-single-parks',
      const Duration(seconds: 2),
      () async {
        try {
          final response = await GMapsService.getPlaceDetailsFromCity(parkId);
          response.fold(
            (l) => print(l),
            (r) async {
              singleParkModel = SingleParkModel.fromJson(r as Map<String, dynamic>);
              await getAllParkImage();
              completer.complete();
            },
          );
        } catch (e) {
          completer.completeError(e);
        }
      },
    );

    return completer.future;
  }

  static List<String> parkImageList = [];
  static Future<void> getAllParkImage() async {
    if (singleParkModel == null) {
      return;
    }
    parkImageList = [];
    int indexLength = singleParkModel?.result?.photos?.length ?? 0;
    if (indexLength > 2) {
      for (var i = 0; i < 3; i++) {
        var photo = await GMapsService.getPlacePhoto(singleParkModel?.result?.photos?[i].photoReference);
        parkImageList.add(photo!);
      }
    }
    if (indexLength > 2) return;
    for (var i in singleParkModel?.result?.photos ?? []) {
      var photo = await GMapsService.getPlacePhoto(i.photoReference);
      parkImageList.add(photo!);
    }
  }

  static late BuildContext _context;
  static getContext(BuildContext context) {
    _context = context;
  }

  static Future deleteMarker(String id) async => await _context.read<MapCubit>().checkOutAll(iD: id);
}
