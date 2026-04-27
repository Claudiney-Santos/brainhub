class BrainfuckException implements Exception {
  final String message;

  BrainfuckException(this.message);

  @override
  String toString() => 'BrainfuckException: $message';
}
