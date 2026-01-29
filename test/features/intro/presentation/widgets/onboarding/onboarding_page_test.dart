import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/features/intro/domain/entities/onboarding_item.dart';
import 'package:fpt_ojt/features/intro/presentation/widgets/onboarding/onboarding_page.dart';

void main() {
  // Setup fake image loading
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('OnboardingPage', () {
    const testItem = OnboardingItem(
      image: 'assets/images/onboarding/onboarding_1.png',
      title: 'Test Title',
      subtitle: 'Test Subtitle',
    );

    Widget makeTestableWidget(Widget child) =>
        MaterialApp(home: Scaffold(body: child));

    testWidgets('should render image, title and subtitle', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingPage(item: testItem)),
      );

      // Assert
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display correct title text', (tester) async {
      // Arrange
      const customItem = OnboardingItem(
        image: 'assets/images/onboarding/onboarding_1.png',
        title: 'Custom Title',
        subtitle: 'Custom Subtitle',
      );

      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingPage(item: customItem)),
      );

      // Assert
      expect(find.text('Custom Title'), findsOneWidget);
      expect(find.text('Custom Subtitle'), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingPage(item: testItem)),
      );

      // Assert - Check Column exists
      expect(find.byType(Column), findsWidgets);

      // Assert - Check SizedBox for spacing exists
      expect(find.byType(SizedBox), findsWidgets);

      // Assert - Check Image widget
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.fit, BoxFit.cover);
    });

    testWidgets('should apply correct text alignment', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingPage(item: testItem)),
      );

      // Assert - Find title text widget
      final titleFinder = find.text('Test Title');
      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.textAlign, TextAlign.center);

      // Assert - Find subtitle text widget
      final subtitleFinder = find.text('Test Subtitle');
      final subtitleWidget = tester.widget<Text>(subtitleFinder);
      expect(subtitleWidget.textAlign, TextAlign.center);
    });

    testWidgets('should use theme text styles', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingPage(item: testItem)),
      );
      await tester.pumpAndSettle();

      // Get the context
      final BuildContext context = tester.element(find.byType(OnboardingPage));
      final theme = Theme.of(context);

      // Assert - Title uses displayMedium
      final titleFinder = find.text('Test Title');
      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style, theme.textTheme.displayMedium);

      // Assert - Subtitle uses bodyLarge
      final subtitleFinder = find.text('Test Subtitle');
      final subtitleWidget = tester.widget<Text>(subtitleFinder);
      expect(subtitleWidget.style, theme.textTheme.bodyLarge);
    });

    testWidgets('should have correct padding for title', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingPage(item: testItem)),
      );

      // Assert - Find Padding widget containing title
      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));

      // Check that there are Padding widgets with horizontal padding of 12
      final hasTitlePadding = paddingWidgets.any(
        (padding) =>
            padding.padding == const EdgeInsets.symmetric(horizontal: 12),
      );
      expect(hasTitlePadding, true);
    });

    testWidgets('should have correct padding for subtitle', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingPage(item: testItem)),
      );

      // Assert - Find Padding widget containing subtitle
      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));

      // Check that there are Padding widgets with horizontal padding of 72
      final hasSubtitlePadding = paddingWidgets.any(
        (padding) =>
            padding.padding == const EdgeInsets.symmetric(horizontal: 72),
      );
      expect(hasSubtitlePadding, true);
    });

    testWidgets('should render with empty strings', (tester) async {
      // Arrange
      const emptyItem = OnboardingItem(
        image: 'assets/images/onboarding/onboarding_1.png',
        title: '',
        subtitle: '',
      );

      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingPage(item: emptyItem)),
      );

      // Assert - Should not throw error
      expect(find.byType(OnboardingPage), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should render with long text content', (tester) async {
      // Arrange
      const longTextItem = OnboardingItem(
        image: 'assets/images/onboarding/onboarding_1.png',
        title: 'This is a very long title that might span multiple lines',
        subtitle:
            'This is a very long subtitle with lots of text that should '
            'wrap properly across multiple lines in the UI',
      );

      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingPage(item: longTextItem)),
      );

      // Assert - Should render without overflow
      expect(find.byType(OnboardingPage), findsOneWidget);
      expect(find.text(longTextItem.title), findsOneWidget);
      expect(find.text(longTextItem.subtitle), findsOneWidget);
    });

    testWidgets('should have correct image dimensions', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(const OnboardingPage(item: testItem)),
      );

      // Assert - Check SizedBox containing image has correct dimensions
      final sizedBoxWidgets = tester.widgetList<SizedBox>(
        find.descendant(
          of: find.byType(OnboardingPage),
          matching: find.byType(SizedBox),
        ),
      );

      // Find the SizedBox with specific dimensions (217x217)
      final imageSizedBox = sizedBoxWidgets.firstWhere(
        (box) => box.width == 217 && box.height == 217,
        orElse: () => const SizedBox(),
      );

      expect(imageSizedBox.width, 217);
      expect(imageSizedBox.height, 217);
    });
  });
}
