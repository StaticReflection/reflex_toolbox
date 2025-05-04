import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:reflex_toolbox/app/data/value/model/execute_result.dart';

Future<ExecuteResult> executeWithCompute(
  String executable,
  List<String> arguments,
) async {
  try {
    return await compute(_runProcess, _ProcessData(executable, arguments));
  } catch (e) {
    return ExecuteResult(
      success: false,
      output: 'Error executing command: ${e.toString().trim()}',
    );
  }
}

class _ProcessData {
  final String executable;
  final List<String> arguments;

  _ProcessData(this.executable, this.arguments);
}

ExecuteResult _runProcess(_ProcessData data) {
  try {
    ProcessResult processResult = Process.runSync(
      data.executable,
      data.arguments,
      stderrEncoding: utf8,
      stdoutEncoding: utf8,
    );

    return ExecuteResult(
      success: true,
      output:
          processResult.stdout.toString().trim() == ''
              ? processResult.stderr.toString().trim()
              : processResult.stdout.toString().trim(),
    );
  } catch (e) {
    return ExecuteResult(
      success: false,
      output: 'Error executing command: ${e.toString().trim()}',
    );
  }
}
