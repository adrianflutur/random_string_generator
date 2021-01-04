import 'package:random_string_generator/random_string_generator.dart';

void main() {
  var generator = RandomStringGenerator(
    minLength: 5,
    maxLength: 25,
  );

  Iterable.generate(10).forEach((_) {
    try {
      var string = generator.generate();
      print(string);
    } on RandomStringGeneratorException catch (e) {
      print(e.message);
    }
  });
}
