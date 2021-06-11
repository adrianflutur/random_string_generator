import 'package:random_string_generator/random_string_generator.dart';

/// The strength of a password.
///
/// You will receive a value from this enum after calling
/// [PasswordStrengthChecker.checkStrength(password)].
enum PasswordStrength {
  VERY_WEAK,
  WEAK,
  GOOD,
  STRONG,
}

/// The RegEx pattern to enforce for loose, medium and tight
/// passwords.
///
/// The password will be matched against all three patterns
/// in order to figure out how strong is the password.
class EnforcingPattern {
  /// Pattern for a weak password.
  final String loosePattern;

  /// Pattern for a medium password.
  final String mediumPattern;

  /// Pattern for a strong password.
  final String tightPattern;

  /// Constructor
  const EnforcingPattern({
    this.loosePattern = r'(?=.*[a-z])(?=.*[A-Z])(?=.{6,})',
    this.mediumPattern = r'((?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{6,}))'
        '|'
        '((?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9])(?=.{8,}))',
    this.tightPattern =
        r'(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{8,})',
  });
}

/// This class is used to check how secure is a password generated
/// with [RandomStringGenerator].
class PasswordStrengthChecker {
  /// Returns a value of type [PasswordStrength], which is how
  /// secure is the given password, according to the provided [EnforcingPattern].
  static PasswordStrength checkStrength(
    String password, {
    EnforcingPattern enforcingPattern = const EnforcingPattern(),
  }) {
    PasswordStrength strength;

    if (RegExp(enforcingPattern.tightPattern).hasMatch(password)) {
      strength = PasswordStrength.STRONG;
    } else if (RegExp(enforcingPattern.mediumPattern).hasMatch(password)) {
      strength = PasswordStrength.GOOD;
    } else if (RegExp(enforcingPattern.loosePattern).hasMatch(password)) {
      strength = PasswordStrength.WEAK;
    } else {
      strength = PasswordStrength.VERY_WEAK;
    }

    return strength;
  }
}
