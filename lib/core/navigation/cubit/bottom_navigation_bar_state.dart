

import 'package:equatable/equatable.dart';

class BottomNavigationState extends Equatable {
  final int index;

  const BottomNavigationState({this.index = 0});

  @override
  List<Object> get props => [index];
}
