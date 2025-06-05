part of 'map_cubit.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

final class MapInitial extends MapState {}

final class MapParksLoaded extends MapState {
  final List<ParkModel> parks;

  const MapParksLoaded(this.parks);

  @override
  List<Object> get props => [parks];
}

final class ShowSearchButton extends MapState {
  final bool show;

  const ShowSearchButton(this.show);

  @override
  List<Object> get props => [show];
}

final class MarkersLoaded extends MapState {
  final Set<gmaps.Marker> markers;

  const MarkersLoaded(this.markers);

  @override
  List<Object> get props => [markers];
}

final class CityMarkersLoaded extends MapState {
  final Set<gmaps.Marker> markers;

  const CityMarkersLoaded(this.markers);

  @override
  List<Object> get props => [markers];
}

final class AutocompleteResults extends MapState {
  final List<ParkModel> predictions;

  const AutocompleteResults(this.predictions);

  @override
  List<Object> get props => [predictions];
}

final class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [message];
}

final class SearchByCountryOnState extends MapState {}

final class SearchByCountryOffState extends MapState {}

final class GetCityParksState extends MapState {}

final class GetCityMarkerState extends MapState {}

final class SingleParkState extends MapState {}

final class ParkByParkState extends MapState {}

final class GotMarkerMapState extends MapState {}

final class ImageByImageState extends MapState {}

final class GetAllPhotosState extends MapState {}

final class StartBuildingPark extends MapState {}

final class EndBuildingPark extends MapState {}

final class CheckedInPark extends MapState {}

final class CheckedOutPark extends MapState {}

final class ZoomInState extends MapState {}

final class ZoomOutState extends MapState {}

final class EndOfMethodState extends MapState {}

final class CityAutocompleteResults extends MapState {
  final List<Predictions> predictions;

  const CityAutocompleteResults(this.predictions);

  @override
  List<Predictions> get props => predictions;
}
