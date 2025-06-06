part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationIndex extends NavigationState {
  final int index;

  const NavigationIndex(this.index);

  @override
  List<Object> get props => [index];
}

class NavigationBottomSheet extends NavigationState {
  final Widget child;

  const NavigationBottomSheet(this.child);

  @override
  List<Object> get props => [child];
}
