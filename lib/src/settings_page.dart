import 'package:flutter/material.dart';

import 'core/core.dart';
import 'favorite_apps_page.dart';
import 'widgets/app_tile.dart' show AppTile;

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
      AppProvider.of(context).notifier.checkLockPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context).notifier;
    return Scaffold(
      body: ListenableBuilder(
        listenable: provider,
        builder: (context, child) {
          final bool hasLockPermission = provider.hasLockPermission;

          return SafeArea(
            child: Padding(
              padding: const .all(24.0),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar.large(title: Text("Setting")),
                  SliverList.list(
                    children: [
                      AppTile(
                        title: "Favorite apps",
                        titleAlign: .start,
                        onTap: () {
                          Navigator.of(context).push(FavoriteAppsPage.route());
                        },
                      ),
                      Divider(height: 24),
                      SizedBox(height: 24),
                      Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(9),
                        ),
                        child: Column(
                          crossAxisAlignment: .stretch,
                          spacing: 8,
                          children: [
                            Text("Double tap lock screen"),
                            if (!hasLockPermission)
                              AppTile(
                                title: "Double tap lock permission",
                                titleAlign: .start,
                                onTap: provider.requestLockPermission,
                              ),

                            if (hasLockPermission)
                              AppTile(
                                title: "double tap lock screen",
                                titleAlign: .start,
                                tralling: Flexible(
                                  child: Switch(
                                    value:
                                        provider.preference.enableDoubleTapLock,
                                    onChanged: provider.toggleDoubleTapLoc,
                                  ),
                                ),
                                onTap: () {
                                  provider.toggleDoubleTapLoc(
                                    !provider.preference.enableDoubleTapLock,
                                  );
                                },
                              ),
                          ],
                        ),
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
