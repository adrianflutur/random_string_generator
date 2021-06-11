# random_string_generator

[![pub package](https://shields.io/pub/v/random_string_generator.svg)](https://pub.dev/packages/random_string_generator)

An easy to use, customizable and secure random string generator.

Can also be used as a password generator by using the following option:

```dart
mustHaveAtLeastOneOfEach = true
```

**NEW** (2.0.0) > `PasswordStrengthChecker`, an util to check how strong a password generated with `RandomStringGenerator` is. The `checkStrength` static function will return one of the 4 enum values available: `VERY_WEAK, WEAK, GOOD and STRONG`, based on the `RegEx` patterns provided to it.

## Usage

### Basic usage

```dart
var generator = RandomStringGenerator(
    fixedLength: 10,
  );

print(generator.generate());
```

This will generate a random string of length 10 which contains:

- random uppercase and lowercase alpha characters
- random digits
- random symbols

### You can change the properties on the generator object

```dart
var generator = RandomStringGenerator(
    fixedLength: 10,
  );
generator.fixedLength = 5;

print(generator.generate());
```

### **WARNING**: The call to **.generate()** will throw **RandomStringGeneratorException** with a **String message** property when the parameters are logically wrong! You should try-catch and print the message to see what was wrong.

### Examples when it will throw:

- If you set **minLength** > **maxLength**.
- If you set only **minLength** or **maxLength**, but you do not set the other one.
- If you set both **fixedLength** and **minLength** + **maxLength**.
- If you set **hasDigits = true**, **hasSymbols = true** and **mustHaveAtLeastOneOfEach = true**, but you set the length to be **1** instead of minimum **2**.

---

### Advanced usage

```dart
var generator = RandomStringGenerator(
    hasAlpha: true,
    alphaCase: AlphaCase.UPPERCASE_ONLY,
    hasDigits: false,
    hasSymbols: true,
    minLength: 10,
    maxLength: 25,
    mustHaveAtLeastOneOfEach: true,
  );

print(generator.generate());
```

This will generate a random string of length between 10 (included) and 25 (included) which is **guaranteed to contain at least one** of below:

- random uppercase-only alpha characters
- random digits
- random symbols

### **Note**: In order for the **at least one of each** feature to work, you must provide a minimum length at least equal to the sum of the **true** boolean values (**hasAlpha**, **hasDigits**, **hasSymbols**) and the **alphaCase**.

### Examples, assuming _mustHaveAtLeastOneOfEach = true_:

1. If **hasAlpha**, **hasDigits**, **hasSymbols** are all set to **true** and **alphaCase** is set to **AlphaCase.LOWERCASE_ONLY**, the total length must be **3** in order to cover all cases.

2. If **hasAlpha**, **hasDigits**, **hasSymbols** are all set to **true** and **alphaCase** is set to **AlphaCase.MIXED_CASE**, the total length must be **(3 + 1 from MIXED_CASE, which means both lower and upper) = 4** in order to cover all cases.

---

### You can also provide custom lists of characters

```dart
var generator = RandomStringGenerator(
    hasAlpha: true,
    alphaCase: AlphaCase.MIXED_CASE,
    hasDigits: true,
    hasSymbols: false,
    minLength: 5,
    maxLength: 10,
    mustHaveAtLeastOneOfEach: false,
    customUpperAlphabet = ['A', 'B', 'X', 'Z'],
    customLowerAlphabet = ['w', 'n', 'h'],
    customDigits = ['1', '2', '3'], // digits as String
    customSymbols = ['?', '@'],
  );

print(generator.generate());
```

For more information, please see the [documentation](https://github.com/adrianflutur/random_string_generator/blob/main/lib/random_string_generator.dart).

---

## License

[MIT](https://github.com/adrianflutur/random_string_generator/blob/master/LICENSE)
