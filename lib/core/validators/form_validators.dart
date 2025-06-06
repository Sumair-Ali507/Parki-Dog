import 'package:form_builder_validators/form_builder_validators.dart';

class FormValidators {
  static String? Function(String?)? name() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Required'),
      FormBuilderValidators.minLength(3, errorText: 'Minimum of 3 characters'),
    ]);
  }

  static String? Function(String?)? email() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Required'),
      FormBuilderValidators.email(),
    ]);
  }

  static String? Function(String?)? password() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Required'),
      FormBuilderValidators.minLength(8,
          errorText: 'Password must be at least 8 characters'),
    ]);
  }

  static String? Function(String?)? confirmPassword(String? password) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.equal(password ?? '',
          errorText: 'Passwords do not match'),
    ]);
  }

  static String? Function(String?)? phone() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Required'),
      FormBuilderValidators.numeric(errorText: 'Must be a number'),
      // FormBuilderValidators.minLength(11,
      //     errorText: 'Phone number must be at least 11 characters.'),
    ]);
  }

  static String? Function(String?)? weight() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.numeric(errorText: 'Must be a number'),
      // FormBuilderValidators.minLength(11,
      //     errorText: 'Phone number must be at least 11 characters.'),
    ]);
  }

  static String? Function(String?)? required() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Required'),
    ]);
  }
}
