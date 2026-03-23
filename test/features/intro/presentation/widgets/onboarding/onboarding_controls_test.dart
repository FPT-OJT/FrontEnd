import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/features/intro/presentation/constants/onboarding_constants.dart';
import 'package:fpt_ojt/features/intro/presentation/widgets/onboarding/onboarding_controls.dart';

void main() {
  group('OnboardingControls', () {
    Widget makeTestableWidget(Widget child) =>
        MaterialApp(home: Scaffold(body: child));

    testWidgets('should show button when showButton is true', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: true, onGetStarted: () {}),
        ),
      );

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(
        find.text(OnboardingConstants.getStartedButtonText),
        findsOneWidget,
      );
    });

    testWidgets('should hide button when showButton is false', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: false, onGetStarted: () {}),
        ),
      );

      // Assert
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('Get started'), findsNothing);
      // SizedBox.shrink should be present when button is hidden
      expect(find.byType(OnboardingControls), findsOneWidget);
    });

    testWidgets('should call onGetStarted when button is tapped', (
      tester,
    ) async {
      // Arrange
      var callbackCalled = false;
      void callback() {
        callbackCalled = true;
      }

      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: true, onGetStarted: callback),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(callbackCalled, true);
    });

    testWidgets('should not crash when onGetStarted is null', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingControls(showButton: true)),
      );

      // Assert - Should render without error
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Verify button can be tapped without error
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
    });

    testWidgets('should have correct button text', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: true, onGetStarted: () {}),
        ),
      );

      // Assert
      expect(
        find.text(OnboardingConstants.getStartedButtonText),
        findsOneWidget,
      );
    });

    testWidgets('should have correct button colors', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: true, onGetStarted: () {}),
        ),
      );

      // Assert - Get button style
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = button.style;

      // Check backgroundColor
      final backgroundColor = style?.backgroundColor?.resolve({});
      expect(backgroundColor, AppColors.secondaryCoral);

      // Check foregroundColor
      final foregroundColor = style?.foregroundColor?.resolve({});
      expect(foregroundColor, AppColors.neutralWhite);
    });

    testWidgets('should have correct button shape', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: true, onGetStarted: () {}),
        ),
      );

      // Assert - Get button style
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = button.style;
      final shape = style?.shape?.resolve({});

      expect(shape, isA<RoundedRectangleBorder>());
      if (shape is RoundedRectangleBorder) {
        expect(shape.borderRadius, BorderRadius.circular(10));
      }
    });

    testWidgets('should have correct container dimensions', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: true, onGetStarted: () {}),
        ),
      );

      // Assert - Find the SizedBox container
      final sizedBox = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(OnboardingControls),
              matching: find.byType(SizedBox),
            )
            .first,
      );

      expect(sizedBox.width, double.infinity);
      expect(sizedBox.height, 48);
    });

    testWidgets('should maintain dimensions when button is hidden', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: false, onGetStarted: () {}),
        ),
      );

      // Assert - Container should still have same dimensions
      final sizedBox = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(OnboardingControls),
              matching: find.byType(SizedBox),
            )
            .first,
      );

      expect(sizedBox.width, double.infinity);
      expect(sizedBox.height, 48);
    });

    testWidgets('should toggle button visibility', (tester) async {
      // Arrange - Start with button hidden
      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: false, onGetStarted: () {}),
        ),
      );

      expect(find.byType(ElevatedButton), findsNothing);

      // Act - Show button
      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: true, onGetStarted: () {}),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Act - Hide button again
      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: false, onGetStarted: () {}),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('button should be tappable multiple times', (tester) async {
      // Arrange
      var tapCount = 0;
      void callback() {
        tapCount++;
      }

      await tester.pumpWidget(
        makeTestableWidget(
          OnboardingControls(showButton: true, onGetStarted: callback),
        ),
      );

      // Act - Tap multiple times
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(tapCount, 3);
    });

    testWidgets('should be a full-width button', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          Center(
            child: SizedBox(
              width: 300,
              child: OnboardingControls(showButton: true, onGetStarted: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Button container should take full width
      final containerBox = tester.getSize(
        find
            .descendant(
              of: find.byType(OnboardingControls),
              matching: find.byType(SizedBox),
            )
            .first,
      );

      expect(containerBox.width, 300);
    });
  });
}
