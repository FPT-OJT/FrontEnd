import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password/forgot_password_email_step.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password/forgot_password_otp_step.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password/forgot_password_reset_step.dart';

void main() {
  group('ForgotPasswordEmailStep', () {
    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForgotPasswordEmailStep(
              formKey: GlobalKey<FormState>(),
              emailController: TextEditingController(),
              isLoading: false,
              onSendCode: () {},
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should validate email input', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();
      bool isCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForgotPasswordEmailStep(
              formKey: formKey,
              emailController: controller,
              isLoading: false,
              onSendCode: () {
                if (formKey.currentState!.validate()) {
                  isCalled = true;
                }
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('Email is required'), findsOneWidget);
      expect(isCalled, false);

      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('Email is invalid'), findsOneWidget);
      expect(isCalled, false);

      await tester.enterText(find.byType(TextFormField), 'valid@email.com');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('Invalid email address'), findsNothing);
      expect(isCalled, true);
    });
  });

  group('ForgotPasswordOtpStep', () {
    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForgotPasswordOtpStep(
              formKey: GlobalKey<FormState>(),
              otpController: TextEditingController(),
              email: 'test@test.com',
              isLoading: false,
              onVerifyOtp: () {},
            ),
          ),
        ),
      );

      expect(find.text('test@test.com'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should validate OTP input', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();
      bool isCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForgotPasswordOtpStep(
              formKey: formKey,
              otpController: controller,
              email: 'test@test.com',
              isLoading: false,
              onVerifyOtp: () {
                if (formKey.currentState!.validate()) {
                  isCalled = true;
                }
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('OTP is required'), findsOneWidget);
      expect(isCalled, false);

      await tester.enterText(find.byType(TextFormField), '123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('OTP is must be 6 digits'), findsOneWidget);
      expect(isCalled, false);

      await tester.enterText(find.byType(TextFormField), '123456');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('OTP is must be 6 digits'), findsNothing);
      expect(isCalled, true);
    });
  });

  group('ForgotPasswordResetStep', () {
    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForgotPasswordResetStep(
              formKey: GlobalKey<FormState>(),
              newPasswordController: TextEditingController(),
              confirmPasswordController: TextEditingController(),
              isLoading: false,
              onResetPassword: () {},
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should validate passwords match', (tester) async {
      final formKey = GlobalKey<FormState>();
      final newPassController = TextEditingController();
      final confirmPassController = TextEditingController();
      bool isCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForgotPasswordResetStep(
              formKey: formKey,
              newPasswordController: newPassController,
              confirmPasswordController: confirmPassController,
              isLoading: false,
              onResetPassword: () {
                if (formKey.currentState!.validate()) {
                  isCalled = true;
                }
              },
            ),
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextFormField).first,
        'password123',
      ); // Valid password
      await tester.enterText(
        find.byType(TextFormField).last,
        'password124',
      ); // Mismatched

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Check for mismatch error on confirm field
      expect(find.text('Password confirmation does not match'), findsOneWidget);
      expect(isCalled, false);

      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      ); // Match
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Password confirmation does not match'), findsNothing);
      expect(isCalled, true);
    });
  });
}
