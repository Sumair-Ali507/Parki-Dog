part of 'location_cubit.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

final class LocationInitial extends LocationState {}

final class LocationLoaded extends LocationState {
  final LatLng position;

  const LocationLoaded(this.position);

  @override
  List<Object> get props => [position];
}
