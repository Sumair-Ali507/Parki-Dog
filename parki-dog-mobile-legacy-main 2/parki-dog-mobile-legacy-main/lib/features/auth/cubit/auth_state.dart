part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthSuccess extends AuthState {
  final UserModel user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

final class SignUpSuccess extends AuthState {
  final UserModel user;

  const SignUpSuccess(this.user);

  @override
  List<Object> get props => [user];
}

final class UserUpdated extends AuthState {}

final class DogCreated extends AuthState {}

final class SignInSuccess extends AuthState {
  // final User user;

  // const SignInSuccess(this.user);

  // @override
  // List<Object> get props => [user];
}

final class UserLoaded extends AuthState {}

final class DogLoaded extends AuthState {}

final class SignOutSuccess extends AuthState {}

final class OnboardSuccess extends AuthState {}

final class UserNotFound extends AuthState {}

final class ExistingAuth extends AuthState {
  final String id;

  const ExistingAuth(this.id);

  @override
  List<Object> get props => [id];
}

final class AccountDataChanged extends AuthState {
  final String name;

  const AccountDataChanged(this.name);

  @override
  List<Object> get props => [name];
}

final class LoadTermsState extends AuthState {}

final class SuccessTermsState extends AuthState {
  final List<TermsModel> terms;

  const SuccessTermsState(this.terms);
}

final class FailureTermsState extends AuthState {
  final String error;

  const FailureTermsState(this.error);
}

final class LoadUserUploadImageState extends AuthState {}

final class SuccessUserUploadImageState extends AuthState {
  final File image;

  const SuccessUserUploadImageState(this.image);
}

final class FailureUserUploadImageState extends AuthState {
  final String error;

  const FailureUserUploadImageState(this.error);
}

final class LoadDogUploadImageState extends AuthState {}

final class SuccessDogUploadImageState extends AuthState {
  final File image;

  const SuccessDogUploadImageState(this.image);
}

final class FailureDogUploadImageState extends AuthState {
  final String error;

  const FailureDogUploadImageState(this.error);
}
