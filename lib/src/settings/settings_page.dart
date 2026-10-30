import 'package:flutter/material.dart';

import '../core/core.dart';
import '../favorite_apps_page.dart';
import '../widgets/app_checkbox_tile.dart';
import '../widgets/app_tile.dart' show AppTile;
import 'widgets/lock_permission_tile.dart';

class SettingsPage extends StatefulWidget {
  const new({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute(builder: (context) => SettingsPage());
  }

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
      AppProvider.of(context).notifier
        ..checkLockPermission()
        ..checkIfDefaultLauncher();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context).notifier;

    const spacer = SizedBox(height: 24);

    return Scaffold(
      body: ListenableBuilder(
        listenable: provider,
        builder: (context, child) {
          final bool isDefaultLauncher = provider.isDefaultLauncher;
          final preference = provider.preference;
          return SafeArea(
            child: Padding(
              padding: const .all(24.0),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar.large(title: Text("Setting")),
                  SliverList.list(
                    children: [
                      if (!isDefaultLauncher) ...[
                        AppTile.setting(
                          title: "Make default launcher",
                          onTap: provider.requestDefaultLauncher,
                        ),
                      ],

                      spacer,

                      AppTile.setting(
                        title: "Favorite apps",
                        onTap: () {
                          Navigator.of(context).push(FavoriteAppsPage.route());
                        },
                      ),

                      spacer,
                      LockPermissionTile(),
                      spacer,
                      Divider(),

                      AppCheckboxTile(
                        title: "quick search",
                        isChecked: preference.quickSearch,
                        onTap: (v) {
                          provider.updatePreference(
                            preference.copyWith(quickSearch: v),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
