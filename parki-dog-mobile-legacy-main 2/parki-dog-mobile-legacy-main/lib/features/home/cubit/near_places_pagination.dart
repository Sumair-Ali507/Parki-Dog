

import 'package:bloc/bloc.dart';
class NearbyPlacesPaginationCubit extends Cubit<int> {
  NearbyPlacesPaginationCubit() : super(5); // Initially show 5 items

  void showMore(int totalItems) {
    if (state + 5 <= totalItems) {
      emit(state +
          5); // Increase the number of items by 5, but not more than totalItems
    }
  }

  void showLess() {
    if (state > 5) {
      emit(state - 5); // Decrease the number of items by 5, but not less than 5
    }
  }
}
