import 'package:flutter_bloc/flutter_bloc.dart';

class DateSelectionCubit extends Cubit<DateTime> {
  DateSelectionCubit() : super(DateTime.now());

  void updateSelectedDate(DateTime newDate) {
    emit(newDate);
  }
}
