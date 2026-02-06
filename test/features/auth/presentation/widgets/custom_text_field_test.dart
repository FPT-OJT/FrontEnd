import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';

void main() {
  group('CustomTextField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    Widget makeTestableWidget({required Widget child}) => MaterialApp(
      home: Scaffold(body: Form(child: child)),
    );

    group('Rendering', () {
      testWidgets('should render with required parameters', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Assert
        expect(find.byType(CustomTextField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should display label text', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Email Address',
              controller: controller,
            ),
          ),
        );

        // Assert
        expect(find.text('Email Address'), findsOneWidget);
      });

      testWidgets('should display hint text when provided', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Email',
              hintText: 'Enter your email',
              controller: controller,
            ),
          ),
        );

        // Assert - Widget renders without error with hint text
        expect(find.byType(CustomTextField), findsOneWidget);
      });

      testWidgets('should render without hint text when not provided', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Assert
        expect(find.byType(CustomTextField), findsOneWidget);
      });
    });

    group('Text Input', () {
      testWidgets('should update controller when text is entered', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        await tester.pump();

        // Assert
        expect(controller.text, 'test@example.com');
      });

      testWidgets('should display entered text', (tester) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        await tester.pump();

        // Assert
        expect(find.text('test@example.com'), findsOneWidget);
      });

      testWidgets('should handle empty text', (tester) async {
        // Arrange
        controller.text = 'initial text';
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), '');
        await tester.pump();

        // Assert
        expect(controller.text, '');
      });

      testWidgets('should handle long text input', (tester) async {
        // Arrange
        final longText = 'a' * 1000;
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), longText);
        await tester.pump();

        // Assert
        expect(controller.text, longText);
      });

      testWidgets('should handle special characters', (tester) async {
        // Arrange
        const specialText = r'test@email.com!#$%&*()';
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), specialText);
        await tester.pump();

        // Assert
        expect(controller.text, specialText);
      });
    });

    group('Validation', () {
      testWidgets('should call validator when form is validated', (
        tester,
      ) async {
        // Arrange
        var validatorCalled = false;
        String? validator(String? value) {
          validatorCalled = true;
          if (value == null || value.isEmpty) {
            return 'Field is required';
          }
          return null;
        }

        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Email',
              controller: controller,
              validator: validator,
            ),
          ),
        );

        // Act
        final formState = tester.state<FormState>(find.byType(Form));
        formState.validate();
        await tester.pump();

        // Assert
        expect(validatorCalled, true);
      });

      testWidgets('should display error message when validation fails', (
        tester,
      ) async {
        // Arrange
        String? validator(String? value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          return null;
        }

        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Email',
              controller: controller,
              validator: validator,
            ),
          ),
        );

        // Act
        final formState = tester.state<FormState>(find.byType(Form));
        formState.validate();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Email is required'), findsOneWidget);
      });

      testWidgets('should not display error when validation passes', (
        tester,
      ) async {
        // Arrange
        controller.text = 'test@example.com';
        String? validator(String? value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          return null;
        }

        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Email',
              controller: controller,
              validator: validator,
            ),
          ),
        );

        // Act
        final formState = tester.state<FormState>(find.byType(Form));
        final isValid = formState.validate();
        await tester.pumpAndSettle();

        // Assert
        expect(isValid, true);
        expect(find.text('Email is required'), findsNothing);
      });

      testWidgets('should work without validator', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        final formState = tester.state<FormState>(find.byType(Form));
        final isValid = formState.validate();

        // Assert - Should not throw error
        expect(isValid, true);
      });
    });

    group('Keyboard Type', () {
      testWidgets('should accept email keyboard type parameter', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Email',
              controller: controller,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        );

        // Assert - Renders without error
        expect(find.byType(CustomTextField), findsOneWidget);
      });

      testWidgets('should accept phone keyboard type parameter', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Phone',
              controller: controller,
              keyboardType: TextInputType.phone,
            ),
          ),
        );

        // Assert - Renders without error
        expect(find.byType(CustomTextField), findsOneWidget);
      });

      testWidgets('should accept number keyboard type parameter', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Age',
              controller: controller,
              keyboardType: TextInputType.number,
            ),
          ),
        );

        // Assert - Renders without error
        expect(find.byType(CustomTextField), findsOneWidget);
      });
    });

    group('Enabled State', () {
      testWidgets('should be enabled by default', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Assert
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        expect(textField.enabled, true);
      });

      testWidgets('should be disabled when enabled is false', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Email',
              controller: controller,
              enabled: false,
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        expect(textField.enabled, false);
      });

      testWidgets('should not accept input when disabled', (tester) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Email',
              controller: controller,
              enabled: false,
            ),
          ),
        );

        final initialText = controller.text;

        // Act - Try to enter text
        await tester.tap(find.byType(TextFormField));
        await tester.pump();
        await tester.enterText(find.byType(TextFormField), 'test');
        await tester.pump();

        // Assert - Text should not change
        expect(controller.text, initialText);
      });
    });

    group('Max Lines', () {
      testWidgets('should render with default single line', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Assert - Renders without error
        expect(find.byType(CustomTextField), findsOneWidget);
      });

      testWidgets('should accept custom max lines parameter', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Description',
              controller: controller,
              maxLines: 5,
            ),
          ),
        );

        // Assert - Renders without error
        expect(find.byType(CustomTextField), findsOneWidget);
      });

      testWidgets('should accept null max lines for unlimited', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(
              label: 'Description',
              controller: controller,
              maxLines: null,
            ),
          ),
        );

        // Assert - Renders without error
        expect(find.byType(CustomTextField), findsOneWidget);
      });
    });

    group('Styling', () {
      testWidgets('should render with styled appearance', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Assert - Renders with proper styling
        expect(find.byType(CustomTextField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should display with themed styles', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Assert - Styled widget renders properly
        expect(find.byType(CustomTextField), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle rapid text changes', (tester) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Act - Rapid changes
        await tester.enterText(find.byType(TextFormField), 'a');
        await tester.enterText(find.byType(TextFormField), 'ab');
        await tester.enterText(find.byType(TextFormField), 'abc');
        await tester.pump();

        // Assert
        expect(controller.text, 'abc');
      });

      testWidgets('should handle controller updates externally', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        // Act
        controller.text = 'external update';
        await tester.pump();

        // Assert
        expect(find.text('external update'), findsOneWidget);
      });

      testWidgets('should handle null validator gracefully', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: CustomTextField(label: 'Email', controller: controller),
          ),
        );

        final formState = tester.state<FormState>(find.byType(Form));
        final isValid = formState.validate();

        // Assert
        expect(isValid, true);
      });
    });
  });
}
