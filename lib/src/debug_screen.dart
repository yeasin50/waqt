import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/core.dart';
import 'core/services/logger.dart';

/// user can preview the errors, later may add send logs option
class DebugScreen extends StatefulWidget {
  const DebugScreen._();

  static MaterialPageRoute route() {
    return MaterialPageRoute(builder: (context) => DebugScreen._());
  }

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  late final future = AppLogger.readLogs();

  String errReport = "";

  String get logHeader {
    final app = AppProvider.of(context).notifier.waqtPkg;
    return "${app.packageName}"
        "\n${app.name}: ${app.versionName}";
  }

  Future<ClipboardData?> copyLog() async {
    final log = ClipboardData(text: "$logHeader\n$errReport");
    await Clipboard.setData(log);
    return log;
  }

  Future<void> shareLog() async {
    ClipboardData? currentClippy = await Clipboard.getData("text/plain");
    if (currentClippy?.text?.startsWith(logHeader) == false) {
      currentClippy = await copyLog();
    }

    final log = await copyLog();
    await AppLogger.sendLogs(log?.text ?? "NONE");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        errReport = snapshot.data ?? "";
        return Scaffold(
          appBar: AppBar(
            title: Text("logs"),
            actions: errReport.isEmpty
                ? []
                : [
                    TextButton(
                      onPressed: copyLog,
                      child: Icon(Icons.copy_outlined),
                    ),
                    TextButton(onPressed: shareLog, child: Text("Send Report")),
                  ],
          ),
          body: SingleChildScrollView(
            padding: .all(24),
            child: Column(
              children: [
                if (snapshot.connectionState == .waiting)
                  CircularProgressIndicator()
                else if (snapshot.hasError)
                  Text("Failed to get log\n ${snapshot.error.toString()}")
                else
                  Text(
                    errReport.isEmpty == true ? " NO logs found" : errReport,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
