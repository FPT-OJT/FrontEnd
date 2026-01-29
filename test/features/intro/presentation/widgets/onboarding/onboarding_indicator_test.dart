import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/features/intro/presentation/widgets/onboarding/onboarding_indicator.dart';

void main() {
  group('OnboardingIndicator', () {
    Widget makeTestableWidget(Widget child) =>
        MaterialApp(home: Scaffold(body: child));

    testWidgets('should render correct number of indicators', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 3, activeIndex: 0),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.circle), findsNWidgets(3));
    });

    testWidgets('should highlight active indicator', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 3, activeIndex: 1),
        ),
      );

      // Assert - Get all icon widgets
      final icons = tester.widgetList<Icon>(find.byIcon(Icons.circle)).toList();
      expect(icons.length, 3);

      // Check first indicator (inactive)
      expect(icons[0].color, AppColors.primaryForest.withAlpha(128));

      // Check second indicator (active)
      expect(icons[1].color, AppColors.primaryForest);

      // Check third indicator (inactive)
      expect(icons[2].color, AppColors.primaryForest.withAlpha(128));
    });

    testWidgets('should highlight first indicator when activeIndex is 0', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 3, activeIndex: 0),
        ),
      );

      // Assert
      final icons = tester.widgetList<Icon>(find.byIcon(Icons.circle)).toList();

      expect(icons[0].color, AppColors.primaryForest);
      expect(icons[1].color, AppColors.primaryForest.withAlpha(128));
      expect(icons[2].color, AppColors.primaryForest.withAlpha(128));
    });

    testWidgets('should highlight last indicator when activeIndex is last', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 3, activeIndex: 2),
        ),
      );

      // Assert
      final icons = tester.widgetList<Icon>(find.byIcon(Icons.circle)).toList();

      expect(icons[0].color, AppColors.primaryForest.withAlpha(128));
      expect(icons[1].color, AppColors.primaryForest.withAlpha(128));
      expect(icons[2].color, AppColors.primaryForest);
    });

    testWidgets('should render single indicator', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 1, activeIndex: 0),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.circle), findsOneWidget);

      final icon = tester.widget<Icon>(find.byIcon(Icons.circle));
      expect(icon.color, AppColors.primaryForest);
    });

    testWidgets('should render many indicators', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 5, activeIndex: 2),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.circle), findsNWidgets(5));

      final icons = tester.widgetList<Icon>(find.byIcon(Icons.circle)).toList();
      expect(icons[2].color, AppColors.primaryForest);
    });

    testWidgets('should have correct icon size', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 3, activeIndex: 0),
        ),
      );

      // Assert
      final icons = tester.widgetList<Icon>(find.byIcon(Icons.circle));

      for (final icon in icons) {
        expect(icon.size, 8);
      }
    });

    testWidgets('should have correct padding between indicators', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 3, activeIndex: 0),
        ),
      );

      // Assert - Find all Padding widgets
      final paddingWidgets = tester
          .widgetList<Padding>(
            find.descendant(
              of: find.byType(OnboardingIndicator),
              matching: find.byType(Padding),
            ),
          )
          .toList();

      // Each indicator should be wrapped in Padding
      expect(paddingWidgets.length, 3);

      for (final padding in paddingWidgets) {
        expect(padding.padding, const EdgeInsets.symmetric(horizontal: 2));
      }
    });

    testWidgets('should be centered in parent', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 3, activeIndex: 1),
        ),
      );

      // Assert - Find Row widget
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should render with zero itemCount', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 0, activeIndex: 0),
        ),
      );

      // Assert - Should render without error
      expect(find.byType(OnboardingIndicator), findsOneWidget);
      expect(find.byIcon(Icons.circle), findsNothing);
    });

    testWidgets('should handle activeIndex out of bounds gracefully', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(
            itemCount: 3,
            activeIndex: 5, // Out of bounds
          ),
        ),
      );

      // Assert - Should render without error
      expect(find.byType(OnboardingIndicator), findsOneWidget);
      expect(find.byIcon(Icons.circle), findsNWidgets(3));

      // All indicators should be inactive since activeIndex is out of bounds
      final icons = tester.widgetList<Icon>(find.byIcon(Icons.circle)).toList();
      for (final icon in icons) {
        expect(icon.color, AppColors.primaryForest.withAlpha(128));
      }
    });

    testWidgets('should handle negative activeIndex', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(
            itemCount: 3,
            activeIndex: -1, // Negative
          ),
        ),
      );

      // Assert - Should render without error
      expect(find.byType(OnboardingIndicator), findsOneWidget);
      expect(find.byIcon(Icons.circle), findsNWidgets(3));

      // All indicators should be inactive
      final icons = tester.widgetList<Icon>(find.byIcon(Icons.circle)).toList();
      for (final icon in icons) {
        expect(icon.color, AppColors.primaryForest.withAlpha(128));
      }
    });

    testWidgets('should update when activeIndex changes', (tester) async {
      // Arrange - Initial render with activeIndex = 0
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 3, activeIndex: 0),
        ),
      );

      var icons = tester.widgetList<Icon>(find.byIcon(Icons.circle)).toList();
      expect(icons[0].color, AppColors.primaryForest);
      expect(icons[1].color, AppColors.primaryForest.withAlpha(128));

      // Act - Update to activeIndex = 1
      await tester.pumpWidget(
        makeTestableWidget(
          const OnboardingIndicator(itemCount: 3, activeIndex: 1),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - New active indicator
      icons = tester.widgetList<Icon>(find.byIcon(Icons.circle)).toList();
      expect(icons[0].color, AppColors.primaryForest.withAlpha(128));
      expect(icons[1].color, AppColors.primaryForest);
      expect(icons[2].color, AppColors.primaryForest.withAlpha(128));
    });
  });
}
