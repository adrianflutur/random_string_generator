import 'package:random_string_generator/random_string_generator.dart';
import 'package:test/test.dart';

void main() {
  group('Password generator tests', () {
    test('Test that password length are correct', () {
      var generator = RandomStringGenerator(fixedLength: 10, hasDigits: false);

      bool hasLengthBetween(String str, int min, int max) {
        return str.length <= max && str.length >= min;
      }

      var generatedList = <String>[];

      Iterable.generate(10).forEach((_) {
        try {
          var string = generator.generate();
          generatedList.add(string);
        } on RandomStringGeneratorException catch (e) {
          print(e.message);
        }
      });

      var ok = true;
      for (var string in generatedList) {
        ok = hasLengthBetween(string, 5, 25);
      }

      expect(ok, isTrue);
    });

    test('Test hasDigits parameter set to false', () {
      var generator = RandomStringGenerator(fixedLength: 10, hasDigits: false);
      final newValue = generator.generate();
      final hasDigit = newValue.contains(RegExp(r'[0-9]'));
      expect(hasDigit, isFalse);
    });

    test('Test hasDigits parameter set to true', () {
      var generator = RandomStringGenerator(fixedLength: 10, hasDigits: true);
      final newValue = generator.generate();
      final hasDigit = newValue.contains(RegExp(r'[0-9]'));
      expect(hasDigit, true);
    });
  });

  group('Password checker tests', () {
    test('Test weak password', () {
      final generator = RandomStringGenerator(
        fixedLength: 6,
        hasAlpha: true,
        hasDigits: false,
        hasSymbols: false,
      );
      final password = generator.generate();
      final strength = PasswordStrengthChecker.checkStrength(password);
      expect(strength, PasswordStrength.WEAK);
    });

    test('Test good password', () {
      final generator = RandomStringGenerator(
        minLength: 6,
        maxLength: 10,
        hasAlpha: true,
        hasDigits: true,
        hasSymbols: false,
        mustHaveAtLeastOneOfEach: true,
      );
      final password = generator.generate();
      final strength = PasswordStrengthChecker.checkStrength(password);
      expect(strength, PasswordStrength.GOOD);
    });

    test('Test strong password', () {
      final generator = RandomStringGenerator(
        minLength: 8,
        maxLength: 12,
        hasAlpha: true,
        hasDigits: true,
        hasSymbols: true,
        mustHaveAtLeastOneOfEach: true,
      );
      final password = generator.generate();
      final strength = PasswordStrengthChecker.checkStrength(password);
      expect(strength, PasswordStrength.STRONG);
    });
  });
}
