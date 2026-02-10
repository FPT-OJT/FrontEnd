class ProfileUpdateConstants {
  ProfileUpdateConstants._();

  // Text constants
  static const String editProfileTitle = 'Edit profile info';
  static const String firstNameLabel = 'First Name';
  static const String lastNameLabel = 'Last Name';
  static const String emailLabel = 'Email';
  static const String mobileNumberLabel = 'Mobile Number';
  static const String updateProfileButton = 'Update profile info';

  // Validation messages
  static const String firstNameRequired = 'First name is required';
  static const String firstNameMinLength =
      'First name must be at least 2 characters';
  static const String firstNameMaxLength =
      'First name must not exceed 50 characters';
  static const String lastNameRequired = 'Last name is required';
  static const String lastNameMinLength =
      'Last name must be at least 2 characters';
  static const String lastNameMaxLength =
      'Last name must not exceed 50 characters';
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String phoneRequired = 'Phone number is required';
  static const String phoneMinLength = 'Phone number must be at least 8 digits';
  static const String phoneMaxLength = 'Phone number must not exceed 15 digits';
  static const String phoneHint = '4324 421 604';

  // Success/Error messages
  static const String updateSuccessMessage = 'Profile updated successfully';
  static const String updateErrorMessage = 'An error occurred';

  // Image paths
  static const String headerImagePath = 'assets/images/profile/head.png';

  // Layout constants
  static const double headerHeight = 120;
  static const double backButtonSize = 36;
  static const double backButtonRadius = 5;
  static const double backButtonIconSize = 20;
  static const double backButtonOpacity = 0.3;
  static const double headerImageHeight = 80;
  static const double headerImageWidth = 100;
  static const double contentBorderRadius = 16;
  static const double contentMinHeight = 700;

  // Field validation length constants
  static const int nameMinLength = 2;
  static const int nameMaxLength = 50;
  static const int phoneMinDigits = 8;
  static const int phoneMaxDigits = 15;

  // Default values
  static const String defaultCountryCode = '+84';
}
