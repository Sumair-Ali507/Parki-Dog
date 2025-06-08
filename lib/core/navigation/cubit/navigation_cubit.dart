import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationIndex(0));

  void changeIndex(int index) {
    emit(NavigationIndex(index));
  }

  void showBottomSheet(Widget child) {
    emit(NavigationBottomSheet(child));
  }
}
