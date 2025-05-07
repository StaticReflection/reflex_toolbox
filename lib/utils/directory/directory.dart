import 'dart:io';

import 'package:path/path.dart' as path;

class DirectoryUtil {
  static Directory get currentDirectory {
    return Directory(path.dirname(Platform.resolvedExecutable));
  }
}
