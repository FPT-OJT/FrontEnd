import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';

void main() {
  group('PasswordTextField', () {
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
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Assert
        expect(find.byType(PasswordTextField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should display label text', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Assert
        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('should render with hint text when provided', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(
              label: 'Password',
              hintText: 'Enter your password',
              controller: controller,
            ),
          ),
        );

        // Assert - Renders without error
        expect(find.byType(PasswordTextField), findsOneWidget);
      });

      testWidgets('should display visibility toggle icon', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Assert
        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      });
    });

    group('Password Visibility Toggle', () {
      testWidgets('should show visibility_off icon initially', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsNothing);
      });

      testWidgets('should toggle to visibility icon when tapped', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.visibility), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsNothing);
      });

      testWidgets('should toggle back to visibility_off icon', (tester) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act - Toggle to visible
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Act - Toggle back to hidden
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsNothing);
      });

      testWidgets('should toggle multiple times correctly', (tester) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act & Assert - Toggle 3 times
        for (var i = 0; i < 3; i++) {
          await tester.tap(find.byType(IconButton));
          await tester.pumpAndSettle();

          final expectedIcon = i.isEven
              ? Icons.visibility
              : Icons.visibility_off;
          expect(find.byIcon(expectedIcon), findsOneWidget);
        }
      });

      testWidgets('should handle rapid visibility toggles', (tester) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act - Rapid toggles
        for (var i = 0; i < 10; i++) {
          await tester.tap(find.byType(IconButton));
          await tester.pump();
        }
        await tester.pumpAndSettle();

        // Assert - Should be hidden (even number of toggles)
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      });
    });

    group('Text Input', () {
      testWidgets('should update controller when text is entered', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), 'mypassword123');
        await tester.pump();

        // Assert
        expect(controller.text, 'mypassword123');
      });

      testWidgets('should maintain text when toggling visibility', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), 'password123');
        await tester.pump();

        // Toggle visibility
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        expect(controller.text, 'password123');
      });

      testWidgets('should handle empty password', (tester) async {
        // Arrange
        controller.text = 'initial';
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), '');
        await tester.pump();

        // Assert
        expect(controller.text, '');
      });

      testWidgets('should handle special characters in password', (
        tester,
      ) async {
        // Arrange
        const password = r'P@ssw0rd!#$%^&*()';
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), password);
        await tester.pump();

        // Assert
        expect(controller.text, password);
      });

      testWidgets('should handle very long password', (tester) async {
        // Arrange
        final longPassword = 'a' * 1000;
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), longPassword);
        await tester.pump();

        // Assert
        expect(controller.text, longPassword);
      });

      testWidgets('should handle controller updates externally', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act
        controller.text = 'external password';
        await tester.pump();

        // Assert - Text should update
        expect(controller.text, 'external password');
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
            return 'Password is required';
          }
          return null;
        }

        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(
              label: 'Password',
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
            return 'Password is required';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        }

        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(
              label: 'Password',
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
        expect(find.text('Password is required'), findsOneWidget);
      });

      testWidgets('should validate correctly with visible password', (
        tester,
      ) async {
        // Arrange
        controller.text = '12345';
        String? validator(String? value) {
          if (value != null && value.length < 6) {
            return 'Too short';
          }
          return null;
        }

        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(
              label: 'Password',
              controller: controller,
              validator: validator,
            ),
          ),
        );

        // Act - Toggle visibility
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Validate
        final formState = tester.state<FormState>(find.byType(Form));
        formState.validate();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Too short'), findsOneWidget);
      });

      testWidgets('should work without validator', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        final formState = tester.state<FormState>(find.byType(Form));
        final isValid = formState.validate();

        // Assert
        expect(isValid, true);
      });
    });

    group('Enabled State', () {
      testWidgets('should be enabled by default', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Assert - Can enter text
        await tester.enterText(find.byType(TextFormField), 'test');
        expect(controller.text, 'test');
      });

      testWidgets('should not accept input when disabled', (tester) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(
              label: 'Password',
              controller: controller,
              enabled: false,
            ),
          ),
        );

        final initialText = controller.text;

        // Act
        await tester.tap(find.byType(TextFormField));
        await tester.pump();
        await tester.enterText(find.byType(TextFormField), 'password');
        await tester.pump();

        // Assert
        expect(controller.text, initialText);
      });

      testWidgets('should render with disabled appearance', (tester) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(
              label: 'Password',
              controller: controller,
              enabled: false,
            ),
          ),
        );

        // Assert - Renders without error
        expect(find.byType(PasswordTextField), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });
    });

    group('Styling', () {
      testWidgets('should render with styled appearance', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Assert - Renders with proper styling
        expect(find.byType(PasswordTextField), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('should display visibility icon with proper styling', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Assert - Icon renders
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty label', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: '', controller: controller),
          ),
        );

        // Assert
        expect(find.byType(PasswordTextField), findsOneWidget);
      });

      testWidgets('should handle very long label', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(
              label: 'This is a very long label that might wrap',
              controller: controller,
            ),
          ),
        );

        // Assert
        expect(find.byType(PasswordTextField), findsOneWidget);
      });

      testWidgets('should handle rapid text input', (tester) async {
        // Arrange
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Act - Rapid input
        await tester.enterText(find.byType(TextFormField), 'a');
        await tester.enterText(find.byType(TextFormField), 'ab');
        await tester.enterText(find.byType(TextFormField), 'abc');
        await tester.pump();

        // Assert
        expect(controller.text, 'abc');
      });

      testWidgets('should handle null hint text', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
          ),
        );

        // Assert
        expect(find.byType(PasswordTextField), findsOneWidget);
      });

      testWidgets('should handle null validator', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: PasswordTextField(label: 'Password', controller: controller),
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
