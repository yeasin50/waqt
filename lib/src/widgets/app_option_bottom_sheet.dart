import 'package:flutter/material.dart';
import 'package:waqt/src/app_service.dart';

import 'app_tile.dart';

class AppOptionBottomSheet extends StatelessWidget {
  const AppOptionBottomSheet._({required this.appInfo, required this.service});

  final AppInfo appInfo;
  final AppService service;

  static void show({
    required BuildContext context,
    required AppInfo appInfo,
    required AppService service,
  }) {
    /// ...
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return AppOptionBottomSheet._(appInfo: appInfo, service: service);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context);

    return Padding(
      padding: const .all(24.0),
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
                  onTap: () => service.unistallApp(appInfo),
                ),
                AppTile(
                  title: "Add to Favorite",
                  titleAlign: .start,
                  onTap: () {},
                ),
                AppTile(
                  title: "Visibility config",
                  titleAlign: .start,
                  onTap: () => service.openAppInfo(appInfo),
                ),
                AppTile(
                  title: "App info",
                  titleAlign: .start,
                  onTap: () => service.openAppInfo(appInfo),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
