import 'package:flutter/material.dart';

import '../core/core.dart';
import '../favorite_apps_page.dart';
import '../widgets/app_tile.dart' show AppTile;
import 'appearance_settings.dart';
import 'widgets/lock_permission_tile.dart';
import 'search_settings_view.dart';

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

    const spacer = SizedBox(height: 32);

    return Scaffold(
      body: ListenableBuilder(
        listenable: provider,
        builder: (context, child) {
          final bool isDefaultLauncher = provider.isDefaultLauncher;
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar.large(title: Text("Setting")),
                SliverList.list(
                  children: [
                    if (!isDefaultLauncher) ...[
                      AppTile.setting(
                        title: "Make default launcher",
                        padding: .symmetric(horizontal: 16, vertical: 12),
                        onTap: provider.requestDefaultLauncher,
                      ),
                    ],

                    spacer,

                    AppTile.setting(
                      title: "Favorite apps",
                      padding: .symmetric(horizontal: 16, vertical: 12),
                      textStyle: TextTheme.of(context).titleMedium,
                      tralling: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.of(context).push(FavoriteAppsPage.route());
                      },
                    ),

                    spacer,
                    LockPermissionTile(),
                    spacer,
                    SearcSettingsView(),
                    spacer,
                    AppearanceSettings(),

                    spacer,
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
