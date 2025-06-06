import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parki_dog/core/resources_manager/strings_manager.dart';
import 'package:parki_dog/core/services/hive/hive.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance;
  static String fcmToken = '';

  static createFireBaseToken() async {
    fcmToken = HiveStorageService.readData(key: 'userToken') ?? '';
    if (fcmToken == '') {
      fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      print('User Token : $fcmToken');
      await HiveStorageService.writeData(key: 'userToken', value: fcmToken);
      setUserToken(userToken: fcmToken);
    }
  }

  static void setUserToken({required String userToken}) async {
    // Reference to the users collection
    CollectionReference usersCollection = _db.collection('users');
    try {
      // Update the document with ID 'User12'
      await usersCollection.doc(GetIt.instance.get<UserModel>().id).update({
        'userToken': userToken,
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<Either<String, User>> signUp(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      StringsManager.socialProfilePicture = null;

      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return left(e.code);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> createUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toMap());
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> editUser(String id, Map<Object, Object> data) async {
    try {
      await _db.collection('users').doc(id).update(data);
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  // static Future<Either<String, bool>> checkUserExists(String id) async {
  //   try {
  //     final result = await _db.collection('users').doc(id).get();
  //     return right(result.exists);
  //   } catch (e) {
  //     return left(e.toString());
  //   }
  // }

  static Future<Either<String, String?>> isSignedIn() async {
    try {
      // await _firebaseAuth.currentUser!.reload();
      final currentUser = _firebaseAuth.currentUser;
      return right(currentUser?.uid);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, User>> signIn(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return left(e.code);
    } catch (e) {
      return left(e.toString());
    }
  }

//new Section
  static Future<Either<String, void>> forgetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(e.code);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, UserModel?>> getUser(String id) async {
    try {
      final DocumentSnapshot user = await _db.collection('users').doc(id).get();

      if (!user.exists) {
        return right(null);
      }

      final userData = user.data()! as Map<String, dynamic>;
      userData['id'] = user.id;

      return right(UserModel.fromMap(userData));
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, DogModel?>> getDog(String id) async {
    try {
      final DocumentSnapshot dog = await _db.collection('dogs').doc(id).get();

      if (!dog.exists) {
        return right(null);
      }

      final dogData = dog.data()! as Map<String, dynamic>;
      dogData['id'] = dog.id;

      return right(DogModel.fromMap(dogData));
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> updateNotificationToken(String dogId) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      await _db.collection('dogs').doc(dogId).update({
        'notificationToken': token,
      });
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, User>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      StringsManager.socialProfilePicture = userCredential.user!.photoURL;

      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return left(e.code);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, User>> signInwithFacebook() async {
    try {
      // Trigger the authentication flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken?.tokenString??'');

      StringsManager.socialProfilePicture =
          'https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=122098927370045754&height=50&width=50&ext=1706283859&hash=AfqHvub2WlgL1CNN6bY__pjilZeRBbzlFzmTsnebKTvUPg';
      // await getFacebookProfilePicture(loginResult.accessToken!.token);

      debugPrint(StringsManager.socialProfilePicture);

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
//if (userCredential.user!=null) return left("cancled");
      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return left(e.code);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, User>> signInWithApple() async {
    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'your_client_id', // Replace with your Apple Developer Client ID
          redirectUri: Uri.parse('your_redirect_uri'), // Replace with your redirect URI
        ),
      );

      // Create a new credential
      final AuthCredential credential = OAuthProvider('apple.com').credential(
        accessToken: result.authorizationCode,
        idToken: result.identityToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      StringsManager.socialProfilePicture = userCredential.user!.photoURL;

      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return left(e.code);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<String?> getFacebookProfilePicture(String accessToken) async {
    final responseid = await http.get(
      Uri.parse('https://graph.facebook.com/v13.0/me?fields=id'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (responseid.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseid.body);
      final userId = data['id'];

      final response = await http.get(
        Uri.parse('https://graph.facebook.com/v13.0/$userId?fields=picture.width(200).height(200)'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        return data['picture']['data']['url'];
      } else {
        throw Exception('Failed to load profile picture');
      }
    }
    return null;
  }

  static Future<Either<String, File>> uploadUserImage() async {
    try {
      late File? image;
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) image = File(pickedImage.path);
      Reference storageReference = _storage.ref('users/').child('images/${DateTime.now().millisecondsSinceEpoch}.png');
      await storageReference.putFile(image!);

      StringsManager.userProfileImage = await storageReference.getDownloadURL();
      print(StringsManager.userProfileImage);
      return Right(image);
    } on FirebaseException catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, File>> uploadDogImage() async {
    try {
      late File? image;
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) image = File(pickedImage.path);
      Reference storageReference = _storage.ref('dogs/').child('images/${DateTime.now().millisecondsSinceEpoch}.png');
      await storageReference.putFile(image!);

      StringsManager.dogImage = await storageReference.getDownloadURL();
      print(StringsManager.dogImage);
      return Right(image);
    } on FirebaseException catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, String>> createDog(String userId, DogModel dogModel) async {
    dogModel.userId = userId;
    dogModel.notificationToken = await FirebaseMessaging.instance.getToken();
    try {
      // Register dog
      final DocumentReference dog = await _db.collection('dogs').add(dogModel.toMap());

      // Add dog to user
      await editUser(userId, {
        'dogs': FieldValue.arrayUnion([dog.id])
      });
      return right(dog.id);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> editDog(String id, Map<Object, dynamic> data) async {
    try {
      await _db.collection('dogs').doc(id).update(data);
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  // new section
  static Future<Either<String, void>> deleteUser({required String id, required String dogId}) async {
    try {
      await _db.collection('users').doc(id).delete();
      await _db.collection('dogs').doc(dogId).delete();
      await _firebaseAuth.currentUser!.delete();

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return left(e.toString());
    }
  }
}
