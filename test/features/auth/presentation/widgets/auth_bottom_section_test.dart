import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/auth_bottom_section.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('AuthBottomSection', () {
    Widget makeTestableWidget({required Widget child}) =>
        MaterialApp(home: Scaffold(body: child));

    group('Rendering', () {
      testWidgets('should render with all required parameters', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        expect(find.byType(AuthBottomSection), findsOneWidget);
        expect(find.text("Don't have an account?"), findsOneWidget);
        expect(find.text('Sign Up'), findsOneWidget);
        expect(find.text('Minstant'), findsOneWidget);
      });

      testWidgets('should display prompt text', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: 'Already have an account?',
                actionText: 'Login',
                routeName: '/login',
              ),
            ),
          );
        });

        // Assert
        expect(find.text('Already have an account?'), findsOneWidget);
      });

      testWidgets('should display action text', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Create Account',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        expect(find.text('Create Account'), findsOneWidget);
      });

      testWidgets('should display logo image', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('should display Minstant brand name', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        expect(find.text('Minstant'), findsOneWidget);
      });

      testWidgets('should render all components together', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: 'Test Prompt',
                actionText: 'Test Action',
                routeName: '/test',
              ),
            ),
          );
        });

        // Assert - All components visible
        expect(find.text('Test Prompt'), findsOneWidget);
        expect(find.text('Test Action'), findsOneWidget);
        expect(find.text('Minstant'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });

    group('Layout Structure', () {
      testWidgets('should have Column as main container', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should have GestureDetector for action text', (
        tester,
      ) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('should have Row for logo and brand name', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        final row = find.byType(Row);
        expect(row, findsWidgets);
      });

      testWidgets('should have SizedBox for spacing', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Styling', () {
      testWidgets('should have correct prompt text style', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        final promptText = tester.widget<Text>(
          find.text("Don't have an account?"),
        );
        expect(promptText.style, AppTextStyles.bodyLarge);
      });

      testWidgets('should have correct action text color', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        final actionText = tester.widget<Text>(find.text('Sign Up'));
        expect(actionText.style?.color, AppColors.secondaryCoral);
      });

      testWidgets('should have correct brand name style', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        final brandText = tester.widget<Text>(find.text('Minstant'));
        expect(brandText.style?.color, AppColors.neutralBlack);
        expect(brandText.style?.fontWeight, FontWeight.bold);
        expect(brandText.style?.fontSize, 24);
      });

      testWidgets('should have correct logo dimensions', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.height, 32);
        expect(image.width, 32);
      });
    });

    group('Interaction', () {
      testWidgets('should have GestureDetector for action text', (
        tester,
      ) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert - GestureDetector exists for tap handling
        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('should wrap action text with GestureDetector', (
        tester,
      ) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert - Only one GestureDetector (for action text)
        expect(find.byType(GestureDetector), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty prompt text', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: '',
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert - Renders without error
        expect(find.byType(AuthBottomSection), findsOneWidget);
      });

      testWidgets('should handle empty action text', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: '',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert - Renders without error
        expect(find.byType(AuthBottomSection), findsOneWidget);
      });

      testWidgets('should handle very long prompt text', (tester) async {
        // Act
        const longText =
            'This is a very long prompt text '
            'that might need to wrap';
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: longText,
                actionText: 'Sign Up',
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert - Text is displayed
        expect(find.text(longText), findsOneWidget);
      });

      testWidgets('should handle very long action text', (tester) async {
        // Act
        const longAction = 'Create A Brand New Account Now';
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: "Don't have an account?",
                actionText: longAction,
                routeName: '/signup',
              ),
            ),
          );
        });

        // Assert
        expect(find.text(longAction), findsOneWidget);
      });

      testWidgets('should handle different route names', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: 'Test',
                actionText: 'Action',
                routeName: '/different/route',
              ),
            ),
          );
        });

        // Assert - Renders without error
        expect(find.byType(AuthBottomSection), findsOneWidget);
      });

      testWidgets('should handle special characters in text', (tester) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: r'Test with @#$%',
                actionText: 'Click & Go!',
                routeName: '/test',
              ),
            ),
          );
        });

        // Assert
        expect(find.text(r'Test with @#$%'), findsOneWidget);
        expect(find.text('Click & Go!'), findsOneWidget);
      });
    });

    group('Component Integration', () {
      testWidgets('should maintain layout with different text lengths', (
        tester,
      ) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: 'Short',
                actionText: 'Click',
                routeName: '/test',
              ),
            ),
          );
        });

        // Assert - All components render
        expect(find.text('Short'), findsOneWidget);
        expect(find.text('Click'), findsOneWidget);
        expect(find.text('Minstant'), findsOneWidget);
      });

      testWidgets('brand section should always render same way', (
        tester,
      ) async {
        // Act
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            makeTestableWidget(
              child: const AuthBottomSection(
                promptText: 'Any text',
                actionText: 'Any action',
                routeName: '/any',
              ),
            ),
          );
        });

        // Assert - Brand is consistent
        expect(find.text('Minstant'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });
  });
}
