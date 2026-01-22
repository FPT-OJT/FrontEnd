typedef Validator = String? Function(String? value);

extension StringX on String? {
  String get orEmpty => this?.trim() ?? '';
  bool get isBlank => orEmpty.isEmpty;
}

class Validators {
  Validators._();
  static Validator required({String message = 'Should not be empty'}) =>
      (value) => value.isBlank ? message : null;

  static Validator minLen(int n, {String? message}) =>
      (value) => value.orEmpty.length < n
      ? (message ?? 'Minimum $n characters')
      : null;
  static Validator maxLen(int n, {String? message}) =>
      (value) => value.orEmpty.length > n
      ? (message ?? 'Maximum $n characters')
      : null;

  static Validator email({String message = 'Invalid email'}) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return (value) =>
        value.isBlank || regex.hasMatch(value.orEmpty) ? null : message;
  }

  static Validator match(RegExp regex, {required String message}) =>
      (value) =>
          value.isBlank || regex.hasMatch(value.orEmpty) ? null : message;

  static Validator sameAs(
    String Function() other, {
    String message = 'Does not match with',
  }) =>
      (value) => value.orEmpty == other().trim() ? null : message;

  static Validator compose(List<Validator> validators) => (value) {
    for (final v in validators) {
      final err = v(value);
      if (err != null) return err;
    }
    return null;
  };
}
