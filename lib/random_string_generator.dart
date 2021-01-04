library random_string_generator;

import 'dart:math';

/// Custom exception for the generator errors
class RandomStringGeneratorException implements Exception {
  /// Exception message
  final String message;

  /// Constructor
  RandomStringGeneratorException(this.message);
}

/// This enum is used in order to specify which case to use for
/// the alpha (letter) characters.
///
/// Note that [AlphaCase.MIXED_CASE] will cause the
/// [mustHaveAtLeastOneOfEach] property to consider it as being
/// two different "has" values.
///
/// For example, when using [AlphaCase.MIXED_CASE] and all the
/// other "has" values as true, you must set minimum length to 4
/// because:
///
/// hasDigits = +1
/// hasSymbols = +1
/// hasAlpha = (using only lowercase or only uppercase) then +1 else +2
///
/// So the total sum = 4 (minimum length)
///
/// Otherwise, if you do not use [mustHaveAtLeastOneOfEach], the minimum
/// length is 1.
enum AlphaCase { UPPERCASE_ONLY, LOWERCASE_ONLY, MIXED_CASE }

/// Random string generator.
///
/// Can be used to generate passwords as well.
class RandomStringGenerator {
  /// Generated string fixed length.
  int fixedLength;

  /// Generated string minimum length. (use min and max OR fixed, not both)
  int minLength;

  /// Generated string maximum length. (use min and max OR fixed, not both)
  int maxLength;

  /// Boolean flag to specify if the generated string should have alpha characters in it.
  bool hasAlpha;

  /// Specify the case (upper, lower or mixed) for the hasAlpha property.
  /// Has effect only if the property is TRUE.
  AlphaCase alphaCase;

  /// Boolean flag to specify if the generated string should have digits in it.
  bool hasDigits;

  /// Boolean flag to specify if the generated string should have symbols in it.
  bool hasSymbols;

  /// This boolean flag is maybe the most interesting thing about this string generator.
  /// Here's how it works:
  ///
  /// Once you set it to TRUE, the generated string will have at least one character
  /// of each "has" boolean property types, and alpha case together.
  ///
  /// Also, now you must specify a minimum string length that is at least equal to
  /// the number of "one of each" characters that you specify.
  ///
  /// Example use case 1:
  ///
  /// ```dart
  /// RandomStringGenerator(
  ///   mustHaveAtLeastOneOfEach: true,
  ///   hasAlpha: true,
  ///   alphaCase: AlphaCase.MIXED,
  ///   hasDigits: true,
  ///   hasSymbols: true,
  ///   length: 4,
  /// );
  /// ```
  ///
  /// This generated a string that has alpha characters (upper and lower),
  /// digits, symbols, and it is guaranteed that it has at least one of the
  /// aforementioned characters. Now you must specify the length
  /// to be at least 4, because you cannot say that you want a string
  /// that has at least one of each character type, which means at least 4 chars,
  /// and then provide a length lower than 4
  ///
  /// Example use case 2:
  ///
  /// ```dart
  /// RandomStringGenerator(
  ///   mustHaveAtLeastOneOfEach: false,
  ///   hasAlpha: true,
  ///   alphaCase: AlphaCase.MIXED,
  ///   hasDigits: true,
  ///   hasSymbols: true,
  ///   length: 1,
  /// );
  /// ```
  ///
  /// Once you set "mustHaveAtLeastOneOfEach" to FALSE, you can set
  /// any value >= 1 as the length because it doesn't need to have at
  /// least one of each anymore. It will just generate randomly.
  bool mustHaveAtLeastOneOfEach;

  /// You might want to provide your custom uppercase alphabet.
  List<String> customUpperAlphabet;

  /// You might want to provide your custom lowercase alphabet.
  List<String> customLowerAlphabet;

  /// You might want to provide your custom digits.
  List<String> customDigits;

  /// You might want to provide your custom symbols.
  List<String> customSymbols;

  /// Secure [Random] instance.
  final Random _secureRandom = Random.secure();

  /// Constructor
  ///
  /// Note:
  /// The properties are not final.
  /// You can modify them after you initialize the object.
  ///
  /// ```dart
  /// var generator = RandomStringGenerator(
  ///     mustHaveAtLeastOneOfEach: true,
  ///     hasAlpha: true,
  ///     alphaCase: AlphaCase.UPPERCASE_ONLY,
  ///     hasDigits: true,
  ///     hasSymbols: true,
  ///     length: 10,
  ///   );
  /// generator.generate();
  ///
  /// generator.hasDigits = false;
  /// generator.generate();
  /// ```
  RandomStringGenerator({
    this.fixedLength,
    this.minLength,
    this.maxLength,
    this.hasAlpha = true,
    this.alphaCase = AlphaCase.MIXED_CASE,
    this.hasDigits = true,
    this.hasSymbols = true,
    this.mustHaveAtLeastOneOfEach = true,
    this.customUpperAlphabet,
    this.customLowerAlphabet,
    this.customDigits,
    this.customSymbols,
  });

  /// Upper alphabet, created by generating the ASCII DEC values
  /// and converting them to their [String] representation.
  static final _upperAlphabetAsciiToString =
      List<int>.generate(26, (int index) => index + 65)
          .map((e) => String.fromCharCode(e))
          .toList();

  /// Upper alphabet, created by generating the ASCII DEC values
  /// and converting them to their [String] representation.
  static final _lowerAlphabetAsciiToString =
      List<int>.generate(26, (int index) => index + 97)
          .map((e) => String.fromCharCode(e))
          .toList();

  /// Upper alphabet, created by generating the ASCII DEC values
  /// and converting them to their [String] representation.
  static final _digitsAsciiToString = List<int>.generate(10, (int index) => index + 48)
      .map((e) => String.fromCharCode(e))
      .toList();

  /// Upper alphabet, created by generating the ASCII DEC values
  /// and converting them to their [String] representation.
  static final _symbolsAsciiToString = <int>[
    ...List<int>.generate(15, (int index) => index + 33),
    ...List<int>.generate(7, (int index) => index + 58),
    ...List<int>.generate(6, (int index) => index + 91),
    ...List<int>.generate(4, (int index) => index + 123),
  ].map((e) => String.fromCharCode(e)).toList();

  /// Generate the string using current properties
  String generate() {
    if ((minLength != null && maxLength != null && fixedLength != null) ||
        (minLength != null && fixedLength != null) ||
        (maxLength != null && fixedLength != null)) {
      throw RandomStringGeneratorException(
        'You should use either fixedLength or minLength and maxLength properties,'
        'not all of them at once.',
      );
    }

    bool usingFixed;

    if (minLength == null ||
        maxLength == null ||
        minLength < 1 ||
        maxLength <= minLength) {
      if (fixedLength == null || fixedLength < 1) {
        // didn't find either fixed or min and max
        throw RandomStringGeneratorException(
          'Random string length should be at least 1. '
          'If using min and max, then: min >= 1 and max > min',
        );
      } else {
        // using fixed
        usingFixed = true;
      }
    } else {
      // using min and max
      usingFixed = false;
    }

    var trueConditionsCounter = 0;

    if (hasAlpha) {
      if (alphaCase == AlphaCase.MIXED_CASE) {
        trueConditionsCounter += 2;
      } else {
        trueConditionsCounter += 1;
      }
    }
    if (hasDigits) {
      trueConditionsCounter += 1;
    }
    if (hasSymbols) {
      trueConditionsCounter += 1;
    }

    if (trueConditionsCounter < 1) {
      throw RandomStringGeneratorException(
        'You should set at least one "has" criteria '
        'to true in order to generate a random string ',
      );
    }

    var lengthToCheck = usingFixed ? fixedLength : minLength;
    if (lengthToCheck < trueConditionsCounter && mustHaveAtLeastOneOfEach) {
      throw RandomStringGeneratorException(
        'You set $trueConditionsCounter "has" params to true and '
        '"mustHaveAtLeastOneOfEach" also to true, '
        'but the (minimum) length ($lengthToCheck) is lower than $trueConditionsCounter, '
        'so this cannot generate at least one of each, '
        'because the total length is lower than that.',
      );
    }

    var _upperAlphabet = (customUpperAlphabet != null && customUpperAlphabet.isNotEmpty)
        ? customUpperAlphabet
        : _upperAlphabetAsciiToString;

    var _lowerAlphabet = (customLowerAlphabet != null && customLowerAlphabet.isNotEmpty)
        ? customLowerAlphabet
        : _lowerAlphabetAsciiToString;

    var _digits = (customDigits != null && customDigits.isNotEmpty)
        ? customDigits
        : _digitsAsciiToString;

    var _symbols = (customSymbols != null && customSymbols.isNotEmpty)
        ? customSymbols
        : _symbolsAsciiToString;

    var everyPossibleCharacterASCII = <String>[];
    var oneOfEach = <String>[];

    if (hasAlpha) {
      switch (alphaCase) {
        case AlphaCase.MIXED_CASE:
          everyPossibleCharacterASCII.addAll(_upperAlphabet);
          everyPossibleCharacterASCII.addAll(_lowerAlphabet);

          if (mustHaveAtLeastOneOfEach) {
            oneOfEach.add(
              _upperAlphabet[_secureRandom.nextInt(_upperAlphabet.length)],
            );
            oneOfEach.add(
              _lowerAlphabet[_secureRandom.nextInt(_lowerAlphabet.length)],
            );
          }
          break;
        case AlphaCase.UPPERCASE_ONLY:
          everyPossibleCharacterASCII.addAll(_upperAlphabet);

          if (mustHaveAtLeastOneOfEach) {
            oneOfEach.add(
              _upperAlphabet[_secureRandom.nextInt(_upperAlphabet.length)],
            );
          }
          break;
        case AlphaCase.LOWERCASE_ONLY:
          everyPossibleCharacterASCII.addAll(_lowerAlphabet);

          if (mustHaveAtLeastOneOfEach) {
            oneOfEach.add(
              _lowerAlphabet[_secureRandom.nextInt(_lowerAlphabet.length)],
            );
          }
          break;
        default:
          everyPossibleCharacterASCII.addAll(_upperAlphabet);
          everyPossibleCharacterASCII.addAll(_lowerAlphabet);

          if (mustHaveAtLeastOneOfEach) {
            oneOfEach.add(
              _upperAlphabet[_secureRandom.nextInt(_upperAlphabet.length)],
            );
            oneOfEach.add(
              _lowerAlphabet[_secureRandom.nextInt(_lowerAlphabet.length)],
            );
          }
      }
    }

    if (hasDigits) {
      everyPossibleCharacterASCII.addAll(_digits);

      if (mustHaveAtLeastOneOfEach) {
        oneOfEach.add(_digits[_secureRandom.nextInt(_digits.length)]);
      }
    }

    if (hasSymbols) {
      everyPossibleCharacterASCII.addAll(_symbols);

      if (mustHaveAtLeastOneOfEach) {
        oneOfEach.add(
          _symbols[_secureRandom.nextInt(_symbols.length)],
        );
      }
    }

    // start building the string
    var generatedString = <String>[];
    int expectedStringLength;

    if (usingFixed) {
      expectedStringLength = fixedLength;
    } else {
      var expectedMinLength = minLength;
      var expectedMaxLength = maxLength;

      expectedStringLength = expectedMinLength +
          _secureRandom.nextInt(
            expectedMaxLength - expectedMinLength + 1,
          );
    }

    if (mustHaveAtLeastOneOfEach) {
      generatedString.addAll(oneOfEach);
      expectedStringLength -= generatedString.length;
    }

    for (var i = 0; i < expectedStringLength; i++) {
      var newChar = everyPossibleCharacterASCII[
          _secureRandom.nextInt(everyPossibleCharacterASCII.length)];
      generatedString.add(newChar);
    }

    return (generatedString..shuffle(_secureRandom)).join();
  }
}
