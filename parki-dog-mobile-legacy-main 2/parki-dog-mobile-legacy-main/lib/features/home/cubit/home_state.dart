part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class NearbyParksLoaded extends HomeState {
  const NearbyParksLoaded(this.parks);

  final List<ParkModel> parks;

  @override
  List<Object> get props => [parks];
}

final class NearbyParksNotFound extends HomeState {}

final class NearbyParksLoading extends HomeState {}

final class HomeError extends HomeState {
  const HomeError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

final class CurrentCheckInLoaded extends HomeState {
  const CurrentCheckInLoaded(this.checkIn);

  final CurrentCheckInCardModel checkIn;

  @override
  List<Object> get props => [checkIn];
}

final class HomeLoading extends HomeState {}

final class SafetyStatusChanged extends HomeState {
  const SafetyStatusChanged(this.id, this.status);

  final String id;
  final String status;

  @override
  List<Object> get props => [id, status];
}

final class FriendshipStatusChanged extends HomeState {
  const FriendshipStatusChanged(this.id, this.status);

  final String id;
  final String status;

  @override
  List<Object> get props => [id, status];
}
