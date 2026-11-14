import 'package:flutter/material.dart';

import '../core/core.dart';
import '../favorite_apps_page.dart';
import 'app_option_bottom_sheet.dart';
import 'app_tile.dart';

class FavoriteAppList extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context).notifier;

    if (provider.favoriteApps.isEmpty) {
      return _EmptyFavoriteList();
    }

    return SingleChildScrollView(
      child: ListenableBuilder(
        listenable: provider,
        builder: (context, child) {
          return Column(
            mainAxisSize: .min,
            spacing: 4,
            children: [
              for (final app in provider.favoriteApps)
                AppTile(
                  title: app.name,
                  onTap: () => provider.launchApp(app),
                  onLongPress: () => AppOptionBottomSheet.show(
                    context: context,
                    appInfo: app,
                    provider: provider,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyFavoriteList extends StatelessWidget {
  const _EmptyFavoriteList();

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(FavoriteAppsPage.route());
      },
      onLongPress: () {}, // This is intentional, It consume parent onLongPress
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          Text(
            'YOUR SPACE',
            style: style.bodyMedium?.copyWith(
              fontSize: 11,
              letterSpacing: 3,
              color: style.bodyMedium?.color?.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Nothing here. Yet.',
            style: style.bodyLarge?.copyWith(
              fontSize: 17,
              color: style.labelLarge?.color?.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
