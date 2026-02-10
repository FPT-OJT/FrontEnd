import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_bloc.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_event.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_state.dart';
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
  String _countryCode = '+84';
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

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
        UpdateProfileRequested(
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
  Widget build(BuildContext context) =>
      BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileLoaded) {
            _firstNameController.text = state.profile.firstName;
            _lastNameController.text = state.profile.lastName;
            _emailController.text = state.profile.email;
            _phoneController.text = state.profile.phoneNumber;
            _countryCode = state.profile.countryCode;
            setState(() {
              _autovalidateMode = AutovalidateMode.disabled;
              _countryCode = state.profile.countryCode;
            });
            return;
          }
          if (state is UpdateProfileFailure) {
            SnackBarUtils.showError(context, state.message);
            return;
          }
          if (state is UpdateProfileSuccess) {
            SnackBarUtils.showSuccess(context, 'Profile updated successfully');
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
                label: 'First Name',
                enabled: state is UpdateProfileLoaded,
                controller: _firstNameController,
                validator: Validators.compose([
                  Validators.required(message: 'First name is required'),
                  Validators.minLen(
                    2,
                    message: 'First name must be at least 2 characters',
                  ),
                  Validators.maxLen(
                    50,
                    message: 'First name must not exceed 50 characters',
                  ),
                ]),
                keyboardType: TextInputType.name,
              ),
              UIGaps.h20,
              CustomTextField(
                label: 'Last Name',
                enabled: state is UpdateProfileLoaded,
                controller: _lastNameController,
                validator: Validators.compose([
                  Validators.required(message: 'Last name is required'),
                  Validators.minLen(
                    2,
                    message: 'Last name must be at least 2 characters',
                  ),
                  Validators.maxLen(
                    50,
                    message: 'Last name must not exceed 50 characters',
                  ),
                ]),
                keyboardType: TextInputType.name,
              ),
              UIGaps.h20,
              CustomTextField(
                label: 'Email',
                enabled: state is UpdateProfileLoaded,
                controller: _emailController,
                validator: Validators.compose([
                  Validators.required(message: 'Email is required'),
                  Validators.email(message: 'Please enter a valid email'),
                ]),
                keyboardType: TextInputType.emailAddress,
              ),
              UIGaps.h20,
              PhoneTextField(
                label: 'Mobile Number',
                enabled: state is UpdateProfileLoaded,
                phoneController: _phoneController,
                hintText: '4324 421 604',
                initialCountryCode: _countryCode,
                countryCodes: state is UpdateProfileLoaded
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
                  Validators.required(message: 'Phone number is required'),
                  Validators.minLen(
                    8,
                    message: 'Phone number must be at least 8 digits',
                  ),
                  Validators.maxLen(
                    15,
                    message: 'Phone number must not exceed 15 digits',
                  ),
                ]),
              ),
              UIGaps.h40,
              PrimaryButton(
                onPressed: _handleUpdateProfile,
                text: 'Update profile info',
                isLoading: state is UpdateProfileLoading,
              ),
            ],
          ),
        ),
      );
}
