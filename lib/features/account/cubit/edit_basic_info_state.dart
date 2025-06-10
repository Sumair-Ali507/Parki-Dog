part of 'edit_basic_info_cubit.dart';

enum EditBasicInfoStatus {
  initial,
  loading,
  success,
  error,
}

extension EditBasicInfoStatusX on EditBasicInfoState {
  bool get isInitial => status == EditBasicInfoStatus.initial;

  bool get isLoading => status == EditBasicInfoStatus.loading;

  bool get isSuccess => status == EditBasicInfoStatus.success;

  bool get isError => status == EditBasicInfoStatus.error;
}

class EditBasicInfoState extends Equatable {
  final EditBasicInfoStatus status;
  final String error;
  final bool? editResponse;

  final String? firstName;
  final String? lastName;
  final Gender? gender;
  final DateTime? birthDate;

  final File? imageFile;

  const EditBasicInfoState({
    this.status = EditBasicInfoStatus.initial,
    this.error = '',
    this.editResponse,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthDate,
    this.imageFile,
  });

  EditBasicInfoState copyWith({
    EditBasicInfoStatus? status,
    String? error,
    bool? editResponse,
    String? firstName,
    String? lastName,
    File? imageFile,
    Gender? gender,
    DateTime? birthDate,
  }) {
    return EditBasicInfoState(
      status: status ?? this.status,
      error: error ?? this.error,
      editResponse: editResponse ?? this.editResponse,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  @override
  List<Object?> get props => [
        status,
        error,
        editResponse,
        firstName,
        lastName,
        gender,
        birthDate,
        imageFile
      ];
}
