import 'package:flutter/material.dart';

import '../core/core.dart';
import '../home_page.dart';
import 'theme.dart';

class WaqtApp extends StatefulWidget {
  const WaqtApp({super.key});

  @override
  State<WaqtApp> createState() => _WaqtAppState();
}

class _WaqtAppState extends State<WaqtApp> {
  final notifier = AppNotifier(AppDatabase());

  @override
  void initState() {
    super.initState();
    notifier.getApps().then((_) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      notifier: notifier,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Waqt',
        theme: AppTheme().baseTheme(context),
        home: HomeScreen(),
      ),
    );
  }
}
