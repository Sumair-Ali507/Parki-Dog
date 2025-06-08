import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/features/account/data/account_repository.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/data/auth_repository.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/data/friend_model.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());

  Future<void> editDogInfo(String id, Map<Object, Object?> data) async {
    final result = await AccountRepository.editDogInfo(id, data);

    result.fold(
      (l) => emit(AccountError(l)),
      (r) => emit(DogInfoUpdated(data)),
    );
  }

  Future<void> editUserInfo(String id, Map<Object, Object?> data) async {
    final result = await AccountRepository.editUserInfo(id, data);

    result.fold(
      (l) => emit(AccountError(l)),
      (r) => emit(UserInfoUpdated(data)),
    );
  }

  Future<List<Map<String, DogModel>>> getFriends(List<FriendModel> friends) async {
    // List<String> ids = friends.map((e) => e.id).toList();
    List<Map<String, DogModel>> dogs = [];

    await Future.wait(
      friends.map(
        (e) async {
          final result = await AuthRepository.getDog(e.id);

          result.fold(
            (l) => emit(AccountError(l)),
            (r) {
              if (r != null) dogs.add({e.status: r});
            },
          );
        },
      ),
    );

    // Sort dogs by status
    dogs.sort((a, b) {
      final statusOrder = {'received': 0, 'sent': 1, 'accepted': 2};
      return statusOrder[a.keys.first]! - statusOrder[b.keys.first]!;
    });

    emit(FriendsLoaded(dogs));
    return dogs;
  }

  deleteUSer({required BuildContext context, required String id}) async {
    final result = await AuthRepository.deleteUser(dogId: GetIt.instance.get<DogModel>().id!, id: id);
    result.fold((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    }, (right) {
      Navigator.pushNamedAndRemoveUntil(context, '/auth/login', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account has been successfully deleted!"),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  late File image;
  Future<void> pickImage({required BuildContext context}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
  }

  double sizeImage = 48.0;
  enlargeImage() {
    if (sizeImage == 48.0) {
      sizeImage = 90;
      emit(HideImage());
    } else {
      sizeImage = 48.0;
      emit(ShowImage());
    }
  }

  double sizeImageDog = 30;
  enlargeImageDog() {
    emit(EnlargeImageInAction());
    if (sizeImageDog == 30) {
      sizeImageDog = 70;
    } else {
      sizeImageDog = 30;
    }
    emit(EnlargeImageDone());
  }

  TextEditingController friendSearchController = TextEditingController();

  clearSearch() {
    searchNames = [];
    friendSearchController.text = '';
    emit(ChangeController());
  }

  // changeSearchController({required String text}) {
  //   friendSearchController.text = text;
  //   emit(ChangeController());
  //   searchUsersNames();
  // }

  List<UserModel> usersNames = [];
  List<UserModel> searchNames = [];
  setUserNames({required List<UserModel> list}) {
    usersNames = list;
  }

  searchUsersNames({required String text}) {
    emit(ChangeController());
    searchNames = [];
    friendSearchController.text = text;
    if (friendSearchController.text == '' || friendSearchController.text.isEmpty) {
      searchNames = [];
    } else {
      for (var i in usersNames) {
        if (((i.firstName?.toLowerCase())!.contains(friendSearchController.text.toLowerCase()) ||
                (i.lastName?.toLowerCase())!.contains(friendSearchController.text.toLowerCase())) &&
            friendSearchController.text != '') {
          searchNames.add(i);
        }
      }
    }

    emit(SearchPeopleState());
  }

  void showToaster() {
    Fluttertoast.showToast(
      msg: 'request have be send',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP_RIGHT,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
    );
  }
}
