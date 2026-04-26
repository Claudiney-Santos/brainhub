import 'dart:math';

class IdGenerator {
  static final Random _random = Random.secure();

  static String generateId() {
    int id = _random.nextInt(1 << 32);
    return id.toRadixString(16).padLeft(8, '0');
  }
}
