import 'dart:collection';

import 'package:brainhub/features/brainfuck_interpreter/brainfuck_exception.dart';

class BrainfuckCode {
  String _code;
  final HashMap<int, int> loopStartPositions = HashMap();
  final HashMap<int, int> loopEndPositions = HashMap();

  String get code => _code;

  BrainfuckCode(this._code) {
    _code = _code.replaceAll(RegExp(r'[^<>+\-.,\[\]]'), '');
    final stack = <int>[];
    for (int i = 0; i < code.length; i++) {
      if (code[i] == '[') {
        stack.add(i);
      } else if (code[i] == ']') {
        if (stack.isEmpty) {
          throw BrainfuckException('Unmatched ] at position $i');
        }
        final start = stack.removeLast();
        loopStartPositions[start] = i;
        loopEndPositions[i] = start;
      }
    }
    if (stack.isNotEmpty) {
      throw BrainfuckException('Unmatched [ at position ${stack.last}');
    }
  }

  @override
  String toString() {
    return code;
  }
}
