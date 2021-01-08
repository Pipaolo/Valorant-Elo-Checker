import 'package:formz/formz.dart';

enum RegionValidatorError { empty }

class Region extends FormzInput<String, RegionValidatorError> {
  // Default region to ap
  const Region.pure() : super.pure('ap');
  const Region.dirty([String value = '']) : super.pure(value);

  @override
  RegionValidatorError validator(String value) {
    return value?.isNotEmpty == true ? null : RegionValidatorError.empty;
  }
}
