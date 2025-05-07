import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:get/get.dart';
import 'package:reflex_toolbox/data/value/model/execute_result.dart';

class ExecuteService extends GetxService {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  StreamSubscription? _subscription;

  final RxBool isRunning = false.obs;

  Future<ExecuteService> init() async {
    return this;
  }

  Future<ExecuteResult> startExecution(
    String executable,
    List<String> args,
  ) async {
    if (isRunning.value) {
      return ExecuteResult(success: false, output: 'ExecuteService is running');
    }

    isRunning.value = true;
    _receivePort = ReceivePort();

    try {
      _isolate = await Isolate.spawn(_runProcessInIsolate, [
        _receivePort!.sendPort,
        executable,
        args,
      ]);

      final result = await _receivePort!.first;
      
      isRunning.value = false;
      _cleanup();

      if (result is String) {
        return ExecuteResult(success: true, output: result);
      } else {
        return ExecuteResult(
          success: false,
          output: 'fail: result(${result.runtimeType}) is not a String',
        );
      }
    } catch (e) {
      isRunning.value = false;
      _cleanup();
      return ExecuteResult(success: false, output: e.toString());
    }
  }

  /// 强制终止任务
  void stopExecution() {
    if (_isolate != null) {
      _isolate!.kill(priority: Isolate.immediate);
      isRunning.value = false;
      _cleanup();
    }
  }

  void _cleanup() {
    _subscription?.cancel();
    _receivePort?.close();
    _isolate = null;
    _receivePort = null;
    _subscription = null;
  }

  @override
  void onClose() {
    stopExecution();
    super.onClose();
  }
}

void _runProcessInIsolate(List data) {
  SendPort sendPort = data[0];
  String executable = data[1];
  List<String> args = List<String>.from(data[2]);

  try {
    ProcessResult result = Process.runSync(
      executable,
      args,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );

    final output =
        result.stdout.toString().trim().isNotEmpty
            ? result.stdout.toString().trim()
            : result.stderr.toString().trim();

    sendPort.send(output);
  } catch (e) {
    sendPort.send('执行出错: ${e.toString()}');
  }
}
