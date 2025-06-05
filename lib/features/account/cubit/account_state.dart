part of 'account_cubit.dart';

sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

final class AccountInitial extends AccountState {}

final class UpdatePhotoState extends AccountState {}

final class AccountLoading extends AccountState {}

final class AccountError extends AccountState {
  final String error;

  const AccountError(this.error);

  @override
  List<Object> get props => [error];
}

final class DogInfoUpdated extends AccountState {
  final Map<Object, Object?> data;

  const DogInfoUpdated(this.data);

  @override
  List<Object> get props => [data];
}

final class UserInfoUpdated extends AccountState {
  final Map<Object, Object?> data;

  const UserInfoUpdated(this.data);

  @override
  List<Object> get props => [data];
}

final class DogDataLoaded extends AccountState {
  final DogModel dog;

  const DogDataLoaded(this.dog);

  @override
  List<Object> get props => [dog];
}

final class FriendsLoaded extends AccountState {
  final List<Map<String, DogModel>> friends;

  const FriendsLoaded(this.friends);

  @override
  List<Object> get props => [friends];
}

class EnlargeImageDone extends AccountState {}

class EnlargeImageInAction extends AccountState {}

class HideImage extends AccountState {}

class ShowImage extends AccountState {}

class SearchPeopleState extends AccountState {}

class ChangeController extends AccountState {}

class SearchList extends AccountState {}
