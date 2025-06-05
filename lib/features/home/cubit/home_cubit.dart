import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:parki_dog/core/services/gmaps/gmaps_service.dart';
import 'package:parki_dog/core/services/notifiactions/notification_service.dart';
import 'package:parki_dog/core/utils.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/home/data/current_check_in_card_model.dart';
import 'package:parki_dog/features/home/data/home_local_repository.dart';
import 'package:parki_dog/features/home/data/home_remote_repository.dart';
import 'package:parki_dog/features/home/data/park_model.dart';
import 'package:parki_dog/features/park/data/check_in_model.dart';
import 'package:parki_dog/features/park/data/park_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  LatLng _previousLocation = const LatLng(0, 0);

  final userSc = StreamController<CurrentCheckInCardModel>();

  Future<void> init(LatLng location) async {
    // emit(HomeLoading());

    await getNearbyParks(location);

    // await getCurrentCheckIn(GetIt.I.get<DogModel>().id!);
  }

  Future<void> getNearbyParks(LatLng location) async {
    // if (!hasLocationChanged(location)) return;
    emit(NearbyParksLoading());
    var localParks = getNearbyParksFromDB(location, 1500);
    print('11111111111111111111111111');
    if (localParks.length > 4) {
      localParks = await Future.wait(localParks.map((e) async {
        e.numberOfDogs = await getNumberOfCheckedInDogs(e.id!);
        e.photoUrl ??= await GMapsService.getPlacePhoto(e.photoReference);
        HomeLocalRepository.updatePark(e);
        print('22222222222222222222222222222');
        return e;
      }).toList());
      emit(NearbyParksLoaded(localParks));
      print('333333333333333333333333333333333');
      return;
    }
    print('444444444444444444444444444444444');
    final response = await GMapsService.nearbySearch('dog park', 'park', location);
    return response.fold(
      (l) {
        emit(HomeError(l));
      },
      (r) async {
        List<ParkModel> parks = await Future.wait(r.map<Future<ParkModel>>(
          (e) async {
            var model = ParkModel.fromGMaps(e as Map<String, dynamic>);
            final photoReference = e['photos']?.first?['photo_reference'];
            model.photoUrl = await GMapsService.getPlacePhoto(photoReference);
            HomeLocalRepository.savePark(model);
            model.numberOfDogs = await getNumberOfCheckedInDogs(model.id!);
            print('555555555555555555555555555555');
            return model;
          },
        ).toList());
        if (parks.isEmpty) {
          emit(NearbyParksNotFound());
        } else {
          emit(NearbyParksLoaded(parks));
        }
      },
    );
  }

  bool hasLocationChanged(LatLng location) {
    final distance = Utils.getDistance(location, _previousLocation);

    if (distance < 100) return false;

    _previousLocation = location;
    return true;
  }

  // Future<ParkModel> getPark(ParkModel park) async {
  //   final response = await HomeRemoteRepository.getParkFromDB(park.id!);

  //   return response.fold(
  //     (l) => park,
  //     (r) async {
  //       if (r == null) {
  //         park = await getParkFromGMaps(park);
  //       } else {
  //         park = r;
  //       }
  //       return park;
  //     },
  //   );
  // }

  // Future<ParkModel> getParkFromGMaps(ParkModel park) async {
  //   final response = await GMapsService.findPlace(park.name!, park.location!);

  //   response.fold(
  //     (l) => print(l),
  //     (r) {
  //       final List candidates = r['candidates'];

  //       park = park.copyWith(
  //         rating: candidates.firstOrNull?['rating']?.toDouble(),
  //         userRatingsTotal: candidates.firstOrNull?['user_ratings_total'],
  //       );
  //     },
  //   );

  //   return park;
  // }

  List<ParkModel> getNearbyParksFromDB(LatLng location, int radius) {
    var parks = HomeLocalRepository.getNearbyParks(location, radius);
    return parks;
  }

  Future<int> getNumberOfCheckedInDogs(String id) async {
    final response = await HomeRemoteRepository.getNumberOfDogs(id);

    return response.fold(
      (l) {
        emit(HomeError(l));
        return 0;
      },
      (r) => r,
    );
  }

  Future<void> getCurrentCheckIn(String dogId) async {
    final response = await HomeRemoteRepository.getCurrentCheckIn(dogId);

    return response.fold(
      (l) => emit(HomeError(l)),
      (checkIn) async {
        if (checkIn != null) {
          final checkedDogs = await ParkRepository.getParkData(checkIn.parkId);

          return checkedDogs.fold(
            (l) => emit(HomeError(l)),
            (dogs) {
              final CurrentCheckInCardModel card = CurrentCheckInCardModel(
                parkId: checkIn.parkId,
                parkName: checkIn.parkName,
                leaveTime: checkIn.leaveTime,
                checkedInDogs: dogs,
              );

              emit(CurrentCheckInLoaded(card));
            },
          );
        }
      },
    );
  }

  Future<CurrentCheckInCardModel?> getCurrentCheckInDetails(CheckInModel checkIn) async {
    final checkedDogs = await ParkRepository.getParkData(checkIn.parkId);

    return checkedDogs.fold(
      (l) {
        emit(HomeError(l));
        return null;
      },
      (dogs) {
        final CurrentCheckInCardModel card = CurrentCheckInCardModel(
          parkId: checkIn.parkId,
          parkName: checkIn.parkName,
          leaveTime: checkIn.leaveTime,
          checkedInDogs: dogs,
        );

        return card;
      },
    );
  }

  Future<void> extendTime(String dogId, String parkId, DateTime leaveTime, DateTime initialLeaveTime) async {
    if (leaveTime.isBefore(initialLeaveTime)) {
      emit(const HomeError('Invalid leave time'));
      return;
    }

    final response = await HomeRemoteRepository.extendTime(dogId, parkId, leaveTime);

    // return response.fold(
    //   (l) => emit(HomeError(l)),
    //   (r) => emit(TimeExtended()),
    // );
  }

  Future<void> checkOutDog(String dogId, String parkId) async {
    final response = await ParkRepository.checkOutDog(dogId, parkId);

    // return response.fold(
    //   (l) => emit(HomeError(l)),
    //   (r) => emit(CheckedOutDog()),
    // );
  }

  Future<void> markUnsafe(String dogId, String enemyId) async {
    final response = await HomeRemoteRepository.markUnsafe(dogId, enemyId);

    return response.fold(
      (l) => emit(HomeError(l)),
      (r) {
        emit(SafetyStatusChanged(enemyId, 'unsafe'));
      },
    );
  }

  Future<void> markSafe(String dogId, String enemyId) async {
    final response = await HomeRemoteRepository.markSafe(dogId, enemyId);

    return response.fold(
      (l) => emit(HomeError(l)),
      (r) {
        emit(SafetyStatusChanged(enemyId, 'safe'));
      },
    );
  }

  Future<void> sendFriendRequest(String dogId, DogModel friend) async {
    final friends = GetIt.I.get<DogModel>().friends;
    final name = GetIt.I.get<DogModel>().name;

    if (friends.map((e) => e.id).contains(friend.id!)) {
      return;
    }

    final response = await HomeRemoteRepository.sendFriendRequest(dogId, friend.id!);

    return response.fold(
      (l) => emit(HomeError(l)),
      (r) {
        NotificationService.sendFcmNotification(
          title: 'Friend Request',
          body: '$name sent you a friend request!',
          token: friend.notificationToken!,
          photoUrl: GetIt.I.get<DogModel>().photoUrl ?? '',
        );
        emit(FriendshipStatusChanged(friend.id!, 'sent'));
      },
    );
  }

  Future<void> cancelFriendRequest(String dogId, String friendId) async {
    final friends = GetIt.I.get<DogModel>().friends;

    if (!friends.map((e) => e.id).contains(friendId)) {
      return;
    }

    final response = await HomeRemoteRepository.cancelFriendRequest(dogId, friendId);

    return response.fold(
      (l) => emit(HomeError(l)),
      (r) {
        // friends.remove(FriendModel(id: friendId, status: 'sent'));
        emit(FriendshipStatusChanged(friendId, 'cancelled'));
      },
    );
  }

  Future<void> acceptFriendRequest(DogModel user, DogModel friend) async {
    final friends = GetIt.I.get<DogModel>().friends;
    if (!friends.map((e) => e.id).contains(friend.id)) {
      return;
    }

    final response = await HomeRemoteRepository.acceptFriendRequest(user.id!, friend.id!);

    return response.fold(
      (l) => emit(HomeError(l)),
      (r) {
        NotificationService.sendFcmNotification(
          title: 'Friend Request',
          body: '${user.name} accepted your friend request!',
          token: friend.notificationToken!,
          photoUrl: user.photoUrl ?? '',
        );
        emit(FriendshipStatusChanged(friend.id!, 'accepted'));
      },
    );
  }

  Future<void> declineFriendRequest(String dogId, String friendId) async {
    final friends = GetIt.I.get<DogModel>().friends;

    if (!friends.map((e) => e.id).contains(friendId)) {
      return;
    }

    final response = await HomeRemoteRepository.declineFriendRequest(dogId, friendId);

    return response.fold(
      (l) => emit(HomeError(l)),
      (r) {
        // friends.remove(FriendModel(id: friendId, status: 'received'));
        emit(FriendshipStatusChanged(friendId, 'declined'));
      },
    );
  }

  Future<void> removeFriend(String dogId, String friendId) async {
    final friends = GetIt.I.get<DogModel>().friends;

    if (!friends.map((e) => e.id).contains(friendId)) {
      return;
    }

    final response = await HomeRemoteRepository.removeFriend(dogId, friendId);

    return response.fold(
      (l) => emit(HomeError(l)),
      (r) {
        // friends.remove(FriendModel(id: friendId, status: 'accepted'));
        emit(FriendshipStatusChanged(friendId, 'removed'));
      },
    );
  }
}
