import 'dart:io';
import 'dart:typed_data';

import 'package:brainhub/features/brainfuck_interpreter/brainfuck_code.dart';
import 'package:brainhub/features/brainfuck_interpreter/brainfuck_exception.dart';
import 'package:brainhub/utils/result.dart';

class BrainfuckInterpreter {
  BrainfuckInterpreter();

  static Result<BrainfuckCode, BrainfuckException> parse(String code) {
      try {
        return Result.ok(BrainfuckCode(code));
      } on BrainfuckException catch (e) {
        return Result.err(e);
      }
  }

  static Future<Result<String, BrainfuckException>> run(String script) async {
    final parsedResult = BrainfuckInterpreter.parse(script);

    switch (parsedResult) {
      case Ok():
        break;
      case Err():
        return Result.err(parsedResult.error);
    }

    final stepLimit = 1000000;

    final bfCode = parsedResult.value;
    String code = bfCode.code;

    final ByteData memory = ByteData(30000);
    int pointer = 0;
    int stepCounter = 0;
    int programCounter = 0;

    StringBuffer outputBuffer = StringBuffer();

    while (programCounter < code.length && stepCounter < stepLimit) {
      final command = code[programCounter];
      switch (command) {
        case '>':
          pointer++;
          break;
        case '<':
          pointer--;
          break;
        case '+':
          memory.setUint8(pointer, (memory.getUint8(pointer) + 1) % 256);
          break;
        case '-':
          memory.setUint8(pointer, (memory.getUint8(pointer) - 1) % 256);
          break;
        case '.':
          outputBuffer.write(String.fromCharCode(memory.getUint8(pointer)));
          break;
        case ',':
          // Input is not implemented in this example
          break;
        case '[':
          if (memory.getUint8(pointer) == 0) {
            programCounter = bfCode.loopStartPositions[programCounter]!;
          }
          break;
        case ']':
          if (memory.getUint8(pointer) != 0) {
            programCounter = bfCode.loopEndPositions[programCounter]!;
          }
          break;
      }
      programCounter++;
      stepCounter++;
    }

    return Result.ok(outputBuffer.toString());
  }
}
