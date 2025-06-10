

import 'package:parki_dog/features/account/cubit/base_use_case.dart';
import 'package:parki_dog/features/account/cubit/failure.dart';
import 'package:parki_dog/features/account/cubit/logout_response.dart';
import 'package:parki_dog/features/account/cubit/profile_response.dart';
import 'package:parki_dog/features/account/cubit/update_dog_use_case.dart';
import 'package:parki_dog/features/account/cubit/update_profile_use_case.dart';

abstract class BaseProfileRepository {
  Future<(Failure?, LogoutResponse?)> logout(NoParameters parameters);
  Future<(Failure?, bool?)> updateProfile(UpdateProfileParameters parameters);
  Future<(Failure?, ProfileResponse?)> updateDog(UpdateDogParameters parameters);
}
