import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_bloc.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_event.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_state.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/profile_update.dart';
import 'package:fpt_ojt/features/shared/utils/snackbar_utils.dart';
import 'package:fpt_ojt/features/shared/widgets/phone_text_field.dart';
import 'package:fpt_ojt/features/shared/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

class UpdateProfileSection extends StatefulWidget {
  const UpdateProfileSection({super.key});

  @override
  State<UpdateProfileSection> createState() => _UpdateProfileSectionState();
}

class _UpdateProfileSectionState extends State<UpdateProfileSection> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _countryCode = ProfileUpdateConstants.defaultCountryCode;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _countryCode = ProfileUpdateConstants.defaultCountryCode;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleUpdateProfile() {
    // Bật autovalidate sau lần validate đầu tiên
    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<UpdateProfileBloc>().add(
        UpdateProfileEvent.updateRequested(
          profile: Profile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            countryCode: _countryCode,
            phoneNumber: _phoneController.text.trim(),
            id: '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
    listener: (context, state) {
      if (state.status == UpdateProfileStatus.loaded && state.profile != null) {
        _firstNameController.text = state.profile!.firstName;
        _lastNameController.text = state.profile!.lastName;
        _emailController.text = state.profile!.email;
        _phoneController.text = state.profile!.phoneNumber;
        _countryCode = state.profile!.countryCode;
        setState(() {
          _autovalidateMode = AutovalidateMode.disabled;
          _countryCode = state.profile!.countryCode;
        });
        return;
      }
      if (state.status == UpdateProfileStatus.failure) {
        SnackBarUtils.showError(
          context,
          state.errorMessage ?? ProfileUpdateConstants.updateErrorMessage,
        );
        return;
      }
      if (state.status == UpdateProfileStatus.success) {
        SnackBarUtils.showSuccess(
          context,
          ProfileUpdateConstants.updateSuccessMessage,
        );
        context.pop();
        return;
      }
    },
    builder: (context, state) => Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        children: [
          CustomTextField(
            label: ProfileUpdateConstants.firstNameLabel,
            enabled: state.status == UpdateProfileStatus.loaded,
            controller: _firstNameController,
            validator: Validators.compose([
              Validators.required(
                message: ProfileUpdateConstants.firstNameRequired,
              ),
              Validators.minLen(
                ProfileUpdateConstants.nameMinLength,
                message: ProfileUpdateConstants.firstNameMinLength,
              ),
              Validators.maxLen(
                ProfileUpdateConstants.nameMaxLength,
                message: ProfileUpdateConstants.firstNameMaxLength,
              ),
            ]),
            keyboardType: TextInputType.name,
          ),
          UIGaps.h20,
          CustomTextField(
            label: ProfileUpdateConstants.lastNameLabel,
            enabled: state.status == UpdateProfileStatus.loaded,
            controller: _lastNameController,
            validator: Validators.compose([
              Validators.required(
                message: ProfileUpdateConstants.lastNameRequired,
              ),
              Validators.minLen(
                ProfileUpdateConstants.nameMinLength,
                message: ProfileUpdateConstants.lastNameMinLength,
              ),
              Validators.maxLen(
                ProfileUpdateConstants.nameMaxLength,
                message: ProfileUpdateConstants.lastNameMaxLength,
              ),
            ]),
            keyboardType: TextInputType.name,
          ),
          UIGaps.h20,
          CustomTextField(
            label: ProfileUpdateConstants.emailLabel,
            enabled: state.status == UpdateProfileStatus.loaded,
            controller: _emailController,
            validator: Validators.compose([
              Validators.required(
                message: ProfileUpdateConstants.emailRequired,
              ),
              Validators.email(message: ProfileUpdateConstants.emailInvalid),
            ]),
            keyboardType: TextInputType.emailAddress,
          ),
          UIGaps.h20,
          PhoneTextField(
            label: ProfileUpdateConstants.mobileNumberLabel,
            enabled: state.status == UpdateProfileStatus.loaded,
            phoneController: _phoneController,
            hintText: ProfileUpdateConstants.phoneHint,
            initialCountryCode: _countryCode,
            countryCodes: state.status == UpdateProfileStatus.loaded
                ? state.countries
                      .map(
                        (country) => CountryPhoneCode(
                          code: country.phoneCode,
                          name: country.name,
                        ),
                      )
                      .toList()
                : [],
            onCountryCodeChanged: (code) {
              setState(() {
                _countryCode = code;
              });
            },
            validator: Validators.compose([
              Validators.required(
                message: ProfileUpdateConstants.phoneRequired,
              ),
              Validators.minLen(
                ProfileUpdateConstants.phoneMinDigits,
                message: ProfileUpdateConstants.phoneMinLength,
              ),
              Validators.maxLen(
                ProfileUpdateConstants.phoneMaxDigits,
                message: ProfileUpdateConstants.phoneMaxLength,
              ),
            ]),
          ),
          UIGaps.h40,
          PrimaryButton(
            onPressed: _handleUpdateProfile,
            text: ProfileUpdateConstants.updateProfileButton,
            isLoading: state.status == UpdateProfileStatus.loading,
          ),
        ],
      ),
    ),
  );
}
