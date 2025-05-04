import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:reflex_toolbox/app/data/value/constants/app_constants.dart';
import 'package:reflex_toolbox/app/utils/directory/directory.dart';

import 'package:path/path.dart' as path;

class LogService extends GetxService {
  static const String _tag = 'LogService';

  late final Logger _logger;
  late final File _logFile;

  Future<LogService> init() async {
    await initLogFile();
    await initLogger();

    debug(_tag, 'Initialization completed');

    return this;
  }

  Future<void> initLogFile() async {
    final Directory logDir = Directory(
      path.join(DirectoryUtil.currentDirectory.path, AppConstants.logDirectory),
    );

    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    final String time = DateFormat(
      'yyyy-MM-dd_HH-mm-ss',
    ).format(DateTime.now());

    _logFile = File(path.join(logDir.path, '$time.log'));

    _logFile.writeAsStringSync('=== Log Started at $time ===\n');
  }

  Future<void> initLogger() async {
    _logger = Logger(
      output: MultiOutput([ConsoleOutput(), FileOutput(file: _logFile)]),
      level: Level.all,
      printer: SimplePrinter(colors: false, printTime: true),
    );
  }

  void trace(String tag, Object message) {
    _logger.t('$tag: $message');
  }

  void debug(String tag, Object message) {
    _logger.d('$tag: $message');
  }

  void info(String tag, Object message) {
    _logger.i('$tag: $message');
  }

  void warning(String tag, Object message) {
    _logger.w('$tag: $message');
  }

  void error(String tag, Object message) {
    _logger.e('$tag: $message');
  }

  void fatal(String tag, Object message) {
    _logger.f('$tag: $message');
  }
}
