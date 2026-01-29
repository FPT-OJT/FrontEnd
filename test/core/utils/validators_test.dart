import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('required', () {
      final validator = Validators.required();

      test('should return null when value is not empty', () {
        expect(validator('test'), null);
      });

      test('should return default message when value is empty', () {
        expect(validator(''), 'Should not be empty');
      });

      test('should return default message when value is null', () {
        expect(validator(null), 'Should not be empty');
      });

      test('should return default message when value is whitespace', () {
        expect(validator('   '), 'Should not be empty');
      });

      test('should return custom message', () {
        final customValidator = Validators.required(message: 'Custom message');
        expect(customValidator(''), 'Custom message');
      });
    });

    group('minLen', () {
      final validator = Validators.minLen(3);

      test('should return null when length is greater than min', () {
        expect(validator('test'), null);
      });

      test('should return null when length is equal to min', () {
        expect(validator('abc'), null);
      });

      test('should return default message when length is less than min', () {
        expect(validator('ab'), 'Minimum 3 characters');
      });

      test('should handle null value as empty string', () {
        expect(validator(null), 'Minimum 3 characters');
      });

      test('should return custom message', () {
        final customValidator = Validators.minLen(3, message: 'Custom message');
        expect(customValidator('ab'), 'Custom message');
      });
    });

    group('maxLen', () {
      final validator = Validators.maxLen(5);

      test('should return null when length is less than max', () {
        expect(validator('test'), null);
      });

      test('should return null when length is equal to max', () {
        expect(validator('12345'), null);
      });

      test('should return default message when length is greater than max', () {
        expect(validator('123456'), 'Maximum 5 characters');
      });

      test('should handle null value as empty string', () {
        expect(
          validator(null),
          null,
        ); // Empty string length is 0, which is <= 5
      });

      test('should return custom message', () {
        final customValidator = Validators.maxLen(5, message: 'Custom message');
        expect(customValidator('123456'), 'Custom message');
      });
    });

    group('email', () {
      final validator = Validators.email();

      test('should return null for valid email', () {
        expect(validator('test@example.com'), null);
      });

      test('should return null when value is blank (optional)', () {
        expect(validator(''), null);
        expect(validator(null), null);
      });

      test('should return default message for invalid email', () {
        expect(validator('invalid_email'), 'Invalid email');
        expect(validator('test@'), 'Invalid email');
        expect(validator('@example.com'), 'Invalid email');
        expect(validator('test@.com'), 'Invalid email');
      });

      test('should return custom message', () {
        final customValidator = Validators.email(message: 'Custom message');
        expect(customValidator('invalid'), 'Custom message');
      });
    });

    group('match', () {
      final regex = RegExp(r'^[0-9]+$');
      final validator = Validators.match(regex, message: 'Must be numbers');

      test('should return null when value matches regex', () {
        expect(validator('123'), null);
      });

      test('should return null when value is blank', () {
        expect(validator(''), null);
        expect(validator(null), null);
      });

      test('should return message when value does not match regex', () {
        expect(validator('abc'), 'Must be numbers');
      });
    });

    group('sameAs', () {
      String otherValue = 'password';
      final validator = Validators.sameAs(() => otherValue);

      test('should return null when values match', () {
        expect(validator('password'), null);
      });

      test('should return default message when values do not match', () {
        expect(validator('other'), 'Does not match with');
      });

      test('should return custom message', () {
        final customValidator = Validators.sameAs(
          () => otherValue,
          message: 'Custom message',
        );
        expect(customValidator('other'), 'Custom message');
      });

      test('should trim values before comparing', () {
        otherValue = ' password ';
        expect(validator('password'), null);
      });
    });

    group('compose', () {
      final validator = Validators.compose([
        Validators.required(),
        Validators.minLen(5),
      ]);

      test('should return null when all validators pass', () {
        expect(validator('hello world'), null);
      });

      test('should return first error encountered', () {
        expect(validator(''), 'Should not be empty');
      });

      test('should return second error if first passes', () {
        expect(validator('hi'), 'Minimum 5 characters');
      });
    });
  });
}
