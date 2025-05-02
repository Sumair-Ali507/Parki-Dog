import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/resources_manager/strings_manager.dart';
import 'package:parki_dog/features/auth/data/auth_repository.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';

import '../../account/data/account_repository.dart';
import '../../account/data/terms_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  UserModel? tempUserModel;
  DogModel? tempDogData;

  final FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<void> signUp(UserModel user, String password) async {
    // emit(AuthLoading());
    final result = await AuthRepository.signUp(user.email!, password);
    return result.fold(
      (error) => emit(AuthError(error)),
      (newUser) async {
        // _userId = newUser.uid;

        tempUserModel = user.copyWith(
          id: newUser.uid,
        );

        // final response = await createUser(tempUserModel!);

        storage.write(key: '_tempData', value: tempUserModel!.toJson());

        emit(SignUpSuccess(tempUserModel!));
      },
    );
  }

  Future<void> onOnboardingComplete() async {
    await createUser(tempUserModel!);
    await createDog(tempUserModel!.id!, tempDogData!);

    if (state is AuthError) return;

    GetIt.I.registerSingleton<UserModel>(tempUserModel!);
    GetIt.I.registerSingleton<DogModel>(tempDogData!);
    emit(OnboardSuccess());
  }

  Future<void> signIn(String email, String password) async {
    // emit(AuthLoading());
    final result = await AuthRepository.signIn(email, password);

    return result.fold(
      (error) => emit(AuthError(error)),
      (user) async {
        // _userId = user.uid;
        await retrieveUserData(user.uid);
      },
    );
  }

//new Section

  Future<void> forgotPassword({required BuildContext context, required String email}) async {
    final result = await AuthRepository.forgetPassword(email: email);

    return result.fold(
      (error) async {
        emit(AuthError(error));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      },
      (success) async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reset mail has been sent successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/auth/login');
      },
    );
  }

  Future<void> retrieveUserData(String uId) async {
    await getUser(uId);
    if (state is AuthError || state is UserNotFound) return;

    final dog = tempUserModel!.dogs!.first;
    await getDog(dog);
    await AuthRepository.updateNotificationToken(dog);
    if (state is AuthError) return;

    GetIt.I.registerSingleton<UserModel>(tempUserModel!);
    GetIt.I.registerSingleton<DogModel>(tempDogData!);

    storage.deleteAll();

    emit(SignInSuccess());
  }

  Future<void> getUser(String userId) async {
    // emit(AuthLoading());
    final result = await AuthRepository.getUser(userId);

    return result.fold(
      (error) => emit(AuthError(error)),
      (user) async {
        if (user == null) {
          emit(UserNotFound());

          var storedTempData = await storage.read(key: '_tempData');

          if (storedTempData != null) {
            tempUserModel = UserModel.fromJson(storedTempData);
          } else {
            await signOut();
          }

          return;
        }

        tempUserModel = user;
        emit(UserLoaded());
      },
    );
  }

  Future<void> getDog(String dogId) async {
    // emit(AuthLoading());
    final result = await AuthRepository.getDog(dogId);

    return result.fold(
      (error) => emit(AuthError(error)),
      (dog) {
        tempDogData = dog;
        // emit(DogLoaded());
      },
    );
  }

  Future<void> createUser(UserModel user) async {
    // emit(AuthLoading());
    final result = await AuthRepository.createUser(user);

    return result.fold(
      (error) => emit(AuthError(error)),
      (_) {},
    );
  }

  // Future<void> updateUser(Map<Object, Object> data) async {
  //   final result = await AuthRepository.editUser(_userId!, data);

  //   return result.fold(
  //     (error) => print(error),
  //     (_) {
  //       emit(UserUpdated());
  //     },
  //   );
  // }

  Future<void> createDog(String uId, DogModel dog) async {
    // emit(AuthLoading());

    final result = await AuthRepository.createDog(uId, dog);

    return result.fold(
      (error) => emit(AuthError(error)),
      (dogId) {
        // _dogId = dogId;
      },
    );
  }

  // Future<void> updateDog(Map<Object, dynamic> data) async {
  //   // emit(AuthLoading());

  //   final result = await AuthRepository.editDog(_dogId!, data);

  //   return result.fold(
  //     (error) => print(error),
  //     (_) {
  //       // emit(AuthSuccess(_currentUserData!));
  //       print('success');
  //     },
  //   );
  // }

  Future<void> signOut() async {
    // emit(AuthLoading());
    final result = await AuthRepository.signOut();

    return result.fold(
      (error) => emit(AuthError(error)),
      (_) {
        GetIt.I.reset();
        storage.deleteAll();
        emit(SignOutSuccess());
      },
    );
  }

  // Future<bool> checkUserExists(String id) async {
  //   final result = await AuthRepository.checkUserExists(id);

  //   return result.fold(
  //     (error) => print(error),
  //     (exists) {
  //       return exists;
  //     },
  //   );
  // }

  Future<void> isSignedIn() async {
    final result = await AuthRepository.isSignedIn();

    return result.fold(
      (error) {
        emit(AuthError(error));
      },
      (isSignedInId) async {
        if (isSignedInId != null) {
          return await retrieveUserData(isSignedInId);
        }
      },
    );
  }

  Future<void> googleSignIn() async {
    emit(AuthLoading());
    final result = await AuthRepository.signInWithGoogle();

    return result.fold(
      (error) => emit(AuthError(error)),
      (user) async {
        // _userId = user.uid;
        tempUserModel = UserModel(
          id: user.uid,
          email: user.email,
          firstName: user.displayName?.split(' ').first,
          lastName: user.displayName?.split(' ').last,
          photoUrl: user.photoURL,
        );

        storage.write(key: '_tempData', value: tempUserModel!.toJson());

        await retrieveUserData(user.uid);
      },
    );
  }

  Future<void> appleSignIn() async {
    emit(AuthLoading());
    final result = await AuthRepository.signInWithApple();

    return result.fold(
      (error) => emit(AuthError(error)),
      (user) async {
        // _userId = user.uid;
        tempUserModel = UserModel(
          id: user.uid,
          email: user.email,
          firstName: user.displayName?.split(' ').first,
          lastName: user.displayName?.split(' ').last,
          photoUrl: user.photoURL,
        );

        storage.write(key: '_tempData', value: tempUserModel!.toJson());

        await retrieveUserData(user.uid);
        emit(SignInSuccess());
      },
    );
  }

  Future<void> facebookSingingIn() async {
    emit(AuthLoading());
    final result = await AuthRepository.signInwithFacebook();

    return result.fold(
      (error) => emit(AuthError(error)),
      (user) async {
        // _userId = user.uid;
        tempUserModel = UserModel(
          id: user.uid,
          email: user.email,
          firstName: user.displayName?.split(' ').first,
          lastName: user.displayName?.split(' ').last,
          photoUrl: StringsManager.socialProfilePicture,
        );

        storage.write(key: '_tempData', value: tempUserModel!.toJson());

        await retrieveUserData(user.uid);
      },
    );
  }

  // new section
  getTerms() async {
    final resut = await AccountRepository.getTermsModel();
    resut.fold((error) => emit(FailureTermsState(error)), (terms) => emit(SuccessTermsState(terms)));
  }

  void accountDataChanged(String name) {
    emit(AccountDataChanged(name));
  }

// new section
  uploadUserImage({required BuildContext context}) async {
    emit(LoadUserUploadImageState());
    try {
      final result = await AuthRepository.uploadUserImage();
      result.fold((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
        emit(FailureUserUploadImageState(error));
      }, (image) {
        emit(SuccessUserUploadImageState(image));
      });
    } catch (e) {
      emit(FailureUserUploadImageState(e.toString()));
    }
  }

  uploadDogImage({required BuildContext context}) async {
    emit(LoadDogUploadImageState());
    try {
      final result = await AuthRepository.uploadDogImage();
      result.fold((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
        emit(FailureDogUploadImageState(error));
      }, (image) {
        emit(SuccessDogUploadImageState(image));
      });
    } catch (e) {
      emit(FailureUserUploadImageState(e.toString()));
    }
  }
}
