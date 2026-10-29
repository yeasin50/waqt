import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("logs")),
      body: SingleChildScrollView(
        padding: .all(24),
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == .waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text("Failed to get log\n ${snapshot.error.toString()}");
            }

            return Text(
              snapshot.data?.isEmpty == true
                  ? " NO logs found"
                  : snapshot.data!,
            );
          },
        ),
      ),
    );
  }
}
