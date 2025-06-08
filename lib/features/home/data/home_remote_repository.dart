import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:parki_dog/features/auth/data/friend_model.dart';
import 'package:parki_dog/features/park/data/check_in_model.dart';

class HomeRemoteRepository {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<Either<String, int>> getNumberOfDogs(String parkId) async {
    try {
      final result = await _db.collection('parks/$parkId/$parkId').get();

      return right(result.docs.length);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, CheckInModel?>> getCurrentCheckIn(
      String dogId) async {
    try {
      final result = await _db.collection('dogs').doc(dogId).get();

      final checkIn = result.data()?['currentCheckIn'];

      if (checkIn == null) return right(null);

      return right(CheckInModel.fromMap(checkIn));
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> extendTime(
      String dogId, String parkId, DateTime leaveTime) async {
    try {
      await _db.doc('parks/$parkId/$parkId/$dogId').update({
        'leaveTime': leaveTime.toUtc(),
      });

      await _db.collection('dogs').doc(dogId).update({
        'currentCheckIn.leaveTime': leaveTime.toUtc(),
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> markUnsafe(
      String dogId, String enemyId) async {
    try {
      await _db.collection('dogs').doc(dogId).update({
        'enemies': FieldValue.arrayUnion([enemyId]),
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> markSafe(
      String dogId, String enemyId) async {
    try {
      await _db.collection('dogs').doc(dogId).update({
        'enemies': FieldValue.arrayRemove([enemyId]),
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> sendFriendRequest(
      String dogId, String friendId) async {
    try {
      final source = FriendModel(id: friendId, status: 'sent');
      final target = FriendModel(id: dogId, status: 'received');

      await _db.collection('dogs').doc(dogId).update({
        'friends': FieldValue.arrayUnion([source.toFirestore()]),
      });

      await _db.collection('dogs').doc(friendId).update({
        'friends': FieldValue.arrayUnion([target.toFirestore()]),
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> acceptFriendRequest(
      String dogId, String friendId) async {
    try {
      var source = FriendModel(id: friendId, status: 'received');
      var target = FriendModel(id: dogId, status: 'sent');

      await _db.collection('dogs').doc(dogId).update({
        'friends': FieldValue.arrayRemove([source.toFirestore()]),
      });

      await _db.collection('dogs').doc(friendId).update({
        'friends': FieldValue.arrayRemove([target.toFirestore()]),
      });

      source = FriendModel(id: friendId, status: 'accepted');
      target = FriendModel(id: dogId, status: 'accepted');

      await _db.collection('dogs').doc(dogId).update({
        'friends': FieldValue.arrayUnion([source.toFirestore()]),
      });

      await _db.collection('dogs').doc(friendId).update({
        'friends': FieldValue.arrayUnion([target.toFirestore()]),
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> declineFriendRequest(
      String dogId, String friendId) async {
    try {
      final source = FriendModel(id: friendId, status: 'received');
      final target = FriendModel(id: dogId, status: 'sent');

      await _db.collection('dogs').doc(dogId).update({
        'friends': FieldValue.arrayRemove([source.toFirestore()]),
      });

      await _db.collection('dogs').doc(friendId).update({
        'friends': FieldValue.arrayRemove([target.toFirestore()]),
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> cancelFriendRequest(
      String dogId, String friendId) async {
    try {
      final source = FriendModel(id: friendId, status: 'sent');
      final target = FriendModel(id: dogId, status: 'received');

      await _db.collection('dogs').doc(dogId).update({
        'friends': FieldValue.arrayRemove([source.toFirestore()]),
      });

      await _db.collection('dogs').doc(friendId).update({
        'friends': FieldValue.arrayRemove([target.toFirestore()]),
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> removeFriend(
      String dogId, String friendId) async {
    try {
      final source = FriendModel(id: friendId, status: 'accepted');
      final target = FriendModel(id: dogId, status: 'accepted');

      await _db.collection('dogs').doc(dogId).update({
        'friends': FieldValue.arrayRemove([source.toFirestore()]),
      });

      await _db.collection('dogs').doc(friendId).update({
        'friends': FieldValue.arrayRemove([target.toFirestore()]),
      });

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }
}
