import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_state.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password_bottom_sheet.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password/forgot_password_email_step.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password/forgot_password_otp_step.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password/forgot_password_reset_step.dart';
import 'package:mocktail/mocktail.dart';

class MockForgotPasswordBloc
    extends MockBloc<ForgotPasswordEvent, ForgotPasswordState>
    implements ForgotPasswordBloc {}

void main() {
  late MockForgotPasswordBloc mockBloc;

  setUp(() {
    mockBloc = MockForgotPasswordBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<ForgotPasswordBloc>.value(
          value: mockBloc,
          child: const ForgotPasswordBottomSheet(),
        ),
      ),
    );
  }

  group('ForgotPasswordBottomSheet', () {
    testWidgets('should render Email step initially', (tester) async {
      when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ForgotPasswordEmailStep), findsOneWidget);
      expect(find.byType(ForgotPasswordOtpStep), findsNothing);
      expect(find.byType(ForgotPasswordResetStep), findsNothing);
    });

    testWidgets('should render OTP step when state is ResetCodeSent', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(const ResetCodeSent(email: 'test@test.com'));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ForgotPasswordOtpStep), findsOneWidget);
      expect(find.byType(ForgotPasswordEmailStep), findsNothing);
    });

    testWidgets('should render Reset Password step when state is OtpVerified', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(const OtpVerified(email: 'test@test.com', otp: '123456'));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ForgotPasswordResetStep), findsOneWidget);
      expect(find.byType(ForgotPasswordOtpStep), findsNothing);
    });

    testWidgets('should close bottom sheet on PasswordResetSuccess', (
      tester,
    ) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([const PasswordResetSuccess()]),
        initialState: ForgotPasswordInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => BlocProvider<ForgotPasswordBloc>.value(
                      value: mockBloc,
                      child: const ForgotPasswordBottomSheet(),
                    ),
                  );
                },
                child: const Text('Show Sheet'),
              ),
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordBottomSheet), findsNothing);
      expect(
        find.text(
          'Password reset successfully! Please login with your new password.',
        ),
        findsOneWidget,
      );
    });
  });
}
