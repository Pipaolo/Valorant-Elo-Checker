import 'package:formz/formz.dart';

enum SaveCredentialsFailure { empty }

class SaveCredentials extends FormzInput<bool, SaveCredentialsFailure> {
  // Default region to ap
  const SaveCredentials.pure() : super.pure(false);
  const SaveCredentials.dirty([bool value = false]) : super.pure(value);

  @override
  SaveCredentialsFailure validator(bool value) {
    return null;
  }
}
