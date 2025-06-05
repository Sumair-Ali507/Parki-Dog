part of 'park_cubit.dart';

sealed class ParkState extends Equatable {
  const ParkState();

  @override
  List<Object> get props => [];
}

final class ParkInitial extends ParkState {}

final class ParkLoading extends ParkState {}

final class ParkError extends ParkState {
  const ParkError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

final class ParkLoaded extends ParkState {
  const ParkLoaded(this.park, this.checkedInDogs);

  final ParkModel park;
  final List<DogModel> checkedInDogs;

  @override
  List<Object> get props => [park, checkedInDogs];
}

final class CheckedInDogsLoaded extends ParkState {
  const CheckedInDogsLoaded(this.checkedInDogs);

  final List<DogModel> checkedInDogs;

  @override
  List<Object> get props => [checkedInDogs];
}

final class CheckedInDog extends ParkState {}

final class CheckedOutDog extends ParkState {}

final class GotSinglePark extends ParkState {}

final class NoSinglePark extends ParkState {}
