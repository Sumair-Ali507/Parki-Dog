
import 'package:equatable/equatable.dart';
import 'package:parki_dog/features/account/cubit/failure.dart';

abstract class BaseUseCase<T, Parameters> {
  Future<(Failure?, T?)> call(Parameters parameters);
}

class NoParameters extends Equatable {
  const NoParameters();

  @override
  List<Object> get props => [];
}
