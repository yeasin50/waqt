import 'package:flutter/material.dart';

import '../core/core.dart';
import '../core/services/app_changes_listner.dart';
import '../core/services/apps_api.g.dart';
import '../core/services/screen_lock_api.g.dart';
import '../home_page.dart';

class WaqtApp extends StatefulWidget {
  const WaqtApp({super.key});

  @override
  State<WaqtApp> createState() => _WaqtAppState();
}

class _WaqtAppState extends State<WaqtApp> with WidgetsBindingObserver {
  final notifier = WaqtAppNotifier(
    AppDatabase(),
    AppService(),
    screenLockApi: ScreenLockApi(),
    appManagerApi: AppManagerApi(),
  )..loadTheme();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // FIXME: #13 #16 Doesn't work on installing app, disable app
    // So  currently merging [SettingsPage] /AppLifecycleState into main widget.
    // if I can't fix it; then  gonna remove the kotlin Corutine/BroadcastReceiver itself
    AppChangeCallback.setUp(
      AppChangeListener((pkg, event) async {
        /// and only refresh during install, uninstall, enable and disable; NOT all the time
        await notifier.refresh();
      }),
    );
    notifier.refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == .resumed) {
      notifier
        ..checkLockPermission()
        ..checkIfDefaultLauncher()
        ..refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      notifier: notifier,
      child: ValueListenableBuilder(
        /// the issue I don't want to update eveything but doing it
        /// the separation  is because might want to refactor in future
        valueListenable: notifier.themeNotifier,
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Waqt',
            theme: value,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
