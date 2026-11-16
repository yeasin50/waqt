import 'package:flutter/material.dart';

import '../app_visibility_config_page.dart';
import '../core/core.dart';
import 'app_tile.dart';

class AppOptionBottomSheet extends StatelessWidget {
  const AppOptionBottomSheet._({required this.appInfo, required this.provider});

  final AppInfo appInfo;
  final WaqtAppNotifier provider;

  static void show({
    required BuildContext context,
    required AppInfo appInfo,
    required WaqtAppNotifier provider,
  }) {
    /// ...
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return AppOptionBottomSheet._(appInfo: appInfo, provider: provider);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context);

    final bool isAlreadyFavirate = provider.favoriteApps.contains(appInfo);

    return Padding(
      padding:
          EdgeInsets.all(24) +
          EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: const .symmetric(vertical: 12.0),
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.settings_outlined),
                Text(appInfo.name, style: style.titleLarge),
              ],
            ),
          ),

          Divider(),

          Padding(
            padding: const .only(left: 24 + 8),
            child: Column(
              crossAxisAlignment: .stretch,
              mainAxisSize: .min,
              children: [
                AppTile(
                  title: "Uninstall",
                  titleAlign: .start,
                  onTap: () {
                    Navigator.of(context).pop();
                    provider.unistallApp(appInfo);
                  },
                ),
                AppTile(
                  title:
                      "${isAlreadyFavirate ? "remove from" : "Add to"} Favorite",
                  titleAlign: .start,
                  onTap: () {
                    provider.toggleFavorite(appInfo, !isAlreadyFavirate);
                    Navigator.of(context).pop();
                  },
                ),
                // AppTile(
                //   title: "Visibility config",
                //   titleAlign: .start,
                //   onTap: () {
                //     final route = AppVisiblityConfigPage.route(
                //       appInfo,
                //       provider,
                //     );
                //     Navigator.of(context).pushReplacement(route);
                //   },
                // ),
                AppTile(
                  title: "App info",
                  titleAlign: .start,
                  onTap: () => provider.openAppInfo(appInfo),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
