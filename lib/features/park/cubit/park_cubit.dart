import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/services/notifiactions/notification_service.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/data/friend_model.dart';
import 'package:parki_dog/features/auth/data/unsocial_with_model.dart';
import 'package:parki_dog/features/home/data/park_model.dart';
import 'package:parki_dog/features/park/data/park_repository.dart';
import 'package:parki_dog/main.dart';

import '../../home/data/city_parks_model.dart';
import '../data/single_park_model.dart';

part 'park_state.dart';

class ParkCubit extends Cubit<ParkState> {
  ParkCubit(this.init) : super(ParkInitial());

  final Function() init;

  Future<void> getParkData() async {
    emit(ParkLoading());

    final ParkModel park = await init();
    final dogs = await getCheckedInDogs(park.id!);

    if (dogs == null) {
      return;
    }

    emit(ParkLoaded(park, dogs));
  }

  Future<List<DogModel>?> getCheckedInDogs(String parkId) async {
    final result = await ParkRepository.getParkData(parkId);

    return result.fold(
      (error) {
        emit(ParkError(error));
        return;
      },
      (data) async {
        for (var element in data) {
          if (element.id != GetIt.I.get<DogModel>().id) {
            element.isSafe = isSafe(element);
          }
        }

        return data;
      },
    );
  }

  Future<void> checkInDog(
      String parkId,
      String parkName,
      String dogId,
      String dogName,
      List<FriendModel> friends,
      DateTime leaveTime,
      Future<void> Function()? checkIn) async {
    if (leaveTime.isBefore(DateTime.now())) {
      emit(const ParkError('Invalid leave time'));
      return;
    }
    if (checkIn != null) {
      await checkIn();
    }
    final result =
        await ParkRepository.checkInDog(parkId, parkName, dogId, leaveTime);

    result.fold(
      (error) => emit(ParkError(error)),
      (data) async {
        // for every friend, get notification token and send notification
        await Future.wait(friends.map(
          (friend) async {
            if (friend.status != 'accepted') return;

            final token = await ParkRepository.getNotificationToken(friend.id);

            token.fold(
              (error) {},
              (token) async {
                await NotificationService.sendFcmNotification(
                  title: 'Friend activity!',
                  body: '$dogName just checked in $parkName.',
                  token: token,
                  photoUrl: GetIt.I.get<DogModel>().photoUrl!,
                );
              },
            );
          },
        ).toList());

        emit(CheckedInDog());
      },
    );
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

  Future<void> checkOutDog(String dogId, String parkId) async {
    final result = await ParkRepository.checkOutDog(dogId, parkId);

    result.fold(
      (error) => emit(ParkError(error)),
      (data) => emit(CheckedOutDog()),
    );
  }

  bool isSafe(DogModel dog) {
    final UnsocialWithModel userUnsocialWith =
        GetIt.I.get<DogModel>().unsocialWith!;

    if (userUnsocialWith.breeds.contains(dog.breed) ||
        userUnsocialWith.gender.contains(dog.gender)) {
      return false;
    }

    if (userUnsocialWith.weight != null) {
      final unsocialWeight = double.parse(userUnsocialWith.weight!);
      final dogWeight = double.parse(dog.weight!);

      if (userUnsocialWith.weightCondition == '>') {
        if (dogWeight > unsocialWeight) {
          return false;
        }
      } else if (userUnsocialWith.weightCondition == '<') {
        if (dogWeight < unsocialWeight) {
          return false;
        }
      }
    }

    return true;
  }

  Future<void> subscribeToNotifications(
      String parkId, UnsocialWithModel unsocialWith) async {
    final result =
        await ParkRepository.subscribeToNotifications(parkId, unsocialWith);

    // result.fold(
    //   (error) => emit(ParkError(error)),
    //   (data) => emit(NotifiedDog()),
    // );
  }

  SingleParkModel? parksModel;
  List<String> parkImageList = [];

  getSingleParkData(
      {required SingleParkModel parkData, required List<String> imagesList}) {
    parksModel = parkData;
    parkImageList = imagesList;
    if (parksModel != null && parkImageList.isNotEmpty) {
      emit(GotSinglePark());
    } else {
      emit(NoSinglePark());
    }
  }
}
