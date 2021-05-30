import 'package:random_string_generator/random_string_generator.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late RandomStringGenerator generator;

    setUp(() {
      generator = RandomStringGenerator(
        minLength: 5,
        maxLength: 25,
      );
    });

    test('First Test', () {
      bool checkStringLength(String str, int min, int max) {
        return str.length <= max && str.length >= min;
      }

      var generatedList = <String>[];

      Iterable.generate(10).forEach((_) {
        try {
          var string = generator.generate();
          print(string);
          generatedList.add(string);
        } on RandomStringGeneratorException catch (e) {
          print(e.message);
        }
      });

      var ok = true;
      for (var string in generatedList) {
        ok = checkStringLength(string, 5, 25);
      }

      expect(ok, isTrue);
    });
  });

  group('Specific tests', () {
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
}
