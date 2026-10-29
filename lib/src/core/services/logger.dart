import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppLogger {
  static Future<File> get _logFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/app_errors.log');
  }

  static Future<void> log(
    String domain,
    Object error, [
    StackTrace? stackTrace,
  ]) async {
    final file = await _logFile;

    final entry =
        '''
[${DateTime.now()}]
DOMAIN: $domain
ERROR: $error
STACKTRACE: ${stackTrace ?? ''}
----------------------------

''';

    await file.writeAsString(entry, mode: FileMode.append, flush: true);
  }

  static Future<String> readLogs() async {
    final file = await _logFile;

    if (!await file.exists()) return '';

    return file.readAsString();
  }

  static Future<void> clearLogs() async {
    final file = await _logFile;

    if (await file.exists()) {
      await file.writeAsString('');
    }
  }
}
