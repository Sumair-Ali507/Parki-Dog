import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/features/account/data/terms_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../../auth/data/dog_model.dart';
import '../cubit/account_cubit.dart';

class AccountRepository {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<Either<String, void>> editDogInfo(String id, Map<Object, Object?> data) async {
    try {
      await db.collection('dogs').doc(id).update(data);
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> editUserInfo(String id, Map<Object, Object?> data) async {
    try {
      await db.collection('users').doc(id).update(data);
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, List<TermsModel>>> getTermsModel() async {
    try {
      final querySnapshot = await db.collection('terms').orderBy("createdAt", descending: false).get();
      List<TermsModel> terms = [];

      for (var i = 0; i < querySnapshot.docs.length; i++) {
        terms.add(TermsModel.fromjs(querySnapshot.docs[i].data()));
      }

      return right(terms);
    } catch (e) {
      return left(e.toString());
    }
  }

  static void updatePhotoUrl({required String newPhotoUrl}) async {
    // Reference to the users collection
    CollectionReference usersCollection = db.collection('users');
    try {
      // Update the document with ID 'User12'
      await usersCollection.doc(GetIt.instance.get<DogModel>().userId).update({
        'photoUrl': newPhotoUrl,
      });
      print('PhotoUrl updated successfully!');
    } catch (e) {
      print('Error updating photoUrl: $e');
    }
  }

  static Future<void> uploadImage({required BuildContext context}) async {
    if (context.read<AccountCubit>().image == null) {
      // No image selected
      return;
    } else {
      try {
        String fileName = basename(context.read<AccountCubit>().image.path);
        // Updated storage path: /users/images
        Reference storageReference = FirebaseStorage.instance.ref().child('users/images/$fileName');
        UploadTask uploadTask = storageReference.putFile(context.read<AccountCubit>().image);
        await uploadTask.whenComplete(() => print('Image uploaded'));
        String downloadURL = await storageReference.getDownloadURL();
        updatePhotoUrl(newPhotoUrl: downloadURL);
        print('Download URL: $downloadURL');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  static void updateDogPhotoUrl({required String newPhotoUrl}) async {
    // Reference to the users collection
    CollectionReference usersCollection = db.collection('dogs');
    try {
      // Update the document with ID 'User12'
      await usersCollection.doc(GetIt.instance.get<DogModel>().id).update({
        'photoUrl': newPhotoUrl,
      });
      print('PhotoUrl updated successfully!');
    } catch (e) {
      print('Error updating photoUrl: $e');
    }
  }

  static Future<void> uploadDogImage({required BuildContext context}) async {
    if (context.read<AccountCubit>().image == null) {
      // No image selected
      return;
    } else {
      try {
        String fileName = basename(context.read<AccountCubit>().image.path);
        // Updated storage path: /users/images
        Reference storageReference = FirebaseStorage.instance.ref().child('dogs/images/$fileName');
        UploadTask uploadTask = storageReference.putFile(context.read<AccountCubit>().image);
        await uploadTask;
        String downloadURL = await storageReference.getDownloadURL();
        updateDogPhotoUrl(newPhotoUrl: downloadURL);
        print('Download URL: $downloadURL');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  static Future getDogData({required String doc}) async {
    DocumentSnapshot x = await db.collection('dogs').doc(doc).get();
    Map<String, dynamic> data = x.data() as Map<String, dynamic>;
    return data;
  }
}
