import 'dart:io';
import 'dart:typed_data';

import 'package:brainhub/features/brainfuck_interpreter/brainfuck_code.dart';
import 'package:brainhub/features/brainfuck_interpreter/brainfuck_exception.dart';
import 'package:brainhub/utils/result.dart';

class BrainfuckInterpreter {
  final int tapeSize;
  final int stepLimit;

  BrainfuckInterpreter({required this.tapeSize, required this.stepLimit});

  static Result<BrainfuckCode, BrainfuckException> parse(String code) {
      try {
        return Result.ok(BrainfuckCode(code));
      } on BrainfuckException catch (e) {
        return Result.err(e);
      }
  }

  Future<Result<String, BrainfuckException>> run(String script) async {
    final parsedResult = BrainfuckInterpreter.parse(script);

    switch (parsedResult) {
      case Ok():
        break;
      case Err():
        return Result.err(parsedResult.error);
    }

    final bfCode = parsedResult.value;
    String code = bfCode.code;

    final ByteData memory = ByteData(tapeSize);
    int pointer = 0;
    int stepCounter = 0;
    int programCounter = 0;

    StringBuffer outputBuffer = StringBuffer();

    try {
      while (programCounter < code.length) {
        if(stepCounter >= stepLimit) {
          throw StackOverflowError();
        }
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
      print("Execution completed in $stepCounter steps at index $pointer in memory.");
    } catch(e) {
      switch(e) {
        case RangeError():
          return Result.err(BrainfuckException('exceeded tape length $tapeSize'));
        case StackOverflowError():
          return Result.err(BrainfuckException('exceeded step limit $stepLimit'));
        default:
          return Result.err(BrainfuckException(e.toString()));
      }
    }

    return Result.ok(outputBuffer.toString());
  }
}
