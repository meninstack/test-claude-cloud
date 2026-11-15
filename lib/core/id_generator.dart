import 'dart:math';

/// Produces short unique ids for routines, tasks, cards and images.
class IdGenerator {
  IdGenerator([Random? random]) : _random = random ?? Random.secure();

  final Random _random;

  static const _alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  String next() {
    final buffer = StringBuffer();
    for (var i = 0; i < 12; i++) {
      buffer.write(_alphabet[_random.nextInt(_alphabet.length)]);
    }
    return buffer.toString();
  }
}
