import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  /// yea could use appInfo dependency but I am not certain that gonna send log this way
  static Future<void> sendLogs(String log) async {
    try {
      final url = Uri.https('github.com', '/yeasin50/waqt/issues/new', {
        'title': 'Bug Report',
        'body': log,
      });

      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e, st) {
      AppLogger.log("AppLogger.sendLogs", e.toString(), st);
    }
  }
}
