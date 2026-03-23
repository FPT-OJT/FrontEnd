class ValidationsConstants {
  ValidationsConstants._();

  static const int firstNameMinLength = 3;
  static const int firstNameMaxLength = 20;
  static const int lastNameMinLength = 3;
  static const int lastNameMaxLength = 20;
  static const int usernameMinLength = 3;
  static const int usernameMaxLength = 20;
  static const int passwordMinLength = 6;
  static const int passwordMaxLength = 20;
  static const int passwordConfirmationMinLength = 8;
  static const int passwordConfirmationMaxLength = 20;

  static const String firstNameRequiredError = 'First name is required';
  static const String firstNameMinLengthError =
      'First name must be at least $firstNameMinLength characters';
  static const String firstNameMaxLengthError =
      'First name must be less than $firstNameMaxLength characters';
  static const String lastNameRequiredError = 'Last name is required';
  static const String lastNameMinLengthError =
      'Last name must be at least $lastNameMinLength characters';
  static const String lastNameMaxLengthError =
      'Last name must be less than $lastNameMaxLength characters';
  static const String usernameRequiredError = 'Username is required';
  static const String usernameMinLengthError =
      'Username must be at least $usernameMinLength characters';
  static const String usernameMaxLengthError =
      'Username must be less than $usernameMaxLength characters';
  static const String usernameInvalidError = 'Username is invalid';
  static const String emailRequiredError = 'Email is required';
  static const String emailInvalidError = 'Email is invalid';
  static const String passwordRequiredError = 'Password is required';
  static const String passwordMinLengthError =
      'Password must be at least $passwordMinLength characters';
  static const String passwordMaxLengthError =
      'Password must be less than $passwordMaxLength characters';
  static const String passwordInvalidError = 'Password is invalid';
  static const String passwordMatchError = 'Passwords do not match';
  static const String passwordConfirmationRequiredError =
      'Password confirmation is required';
  static const String passwordConfirmationMinLengthError =
      'Password confirmation must be at least $passwordConfirmationMinLength characters';
  static const String passwordConfirmationMaxLengthError =
      'Password confirmation must be less than $passwordConfirmationMaxLength characters';
  static const String passwordConfirmationInvalidError =
      'Password confirmation is invalid';
  static const String passwordConfirmationMatchError =
      'Password confirmation does not match';
  static const int otpMinLength = 6;
  static const int otpMaxLength = 6;
  static const String otpRequiredError = 'OTP is required';
  static const String otpInvalidError = 'OTP is must be 6 digits';
}
