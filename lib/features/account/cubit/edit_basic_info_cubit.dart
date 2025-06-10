import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parki_dog/features/account/cubit/profile_response.dart';
import 'package:parki_dog/features/account/cubit/update_profile_use_case.dart';
import 'package:parki_dog/features/account/view/widgets/gender_selection_widget.dart';
import 'package:parki_dog/generated/locale_keys.g.dart';


part 'edit_basic_info_state.dart';

class EditBasicInfoCubit extends Cubit<EditBasicInfoState> {
  UpdateProfileUseCase updateProfileUseCase;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final basicInfoGormKey = GlobalKey<FormState>();
  void updateInfoProcess({
    String? firstName,
    String? lastName,
    Gender? gender,
    DateTime? birthDate,
    File? imageFile,
  }) {
    emit(state.copyWith(
      firstName: firstName ?? state.firstName,
      lastName: lastName ?? state.lastName,
      gender: gender ?? state.gender,
      birthDate: birthDate ?? state.birthDate,
      imageFile: imageFile ?? state.imageFile,
    ));
  }
init(){
  // firstNameController.text = profile?.firstName??'';
  // lastNameController.text = profile?.lastName??'';
  // genderController.text = LocaleKeys.gender_gMale.tr();
  // birthDateController.text = '';
}
  EditBasicInfoCubit(this.updateProfileUseCase) : super(const EditBasicInfoState());
  Future<void> pickDogOwnerImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      EditBasicInfoState(imageFile: File(image.path));
    }
  }

  save() async {
    emit(state.copyWith(status: EditBasicInfoStatus.loading));
    final result = await updateProfileUseCase(UpdateProfileParameters(firstName: firstNameController.text,
        lastName: lastNameController.text));
    if (result.$1 != null) {
      emit(state.copyWith(
        status: EditBasicInfoStatus.error,
        error: result.$1!.message.tr(),
      ));
    } else {
      emit(state.copyWith(status: EditBasicInfoStatus.success, editResponse: true));
    }
  }



  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    genderController.dispose();
    birthDateController.dispose();
    return super.close();
  }
}
