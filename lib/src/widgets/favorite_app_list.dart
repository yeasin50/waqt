import 'package:flutter/material.dart';

import '../core/core.dart';
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
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        Text(
          'YOUR SPACE',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 3,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),

        const SizedBox(height: 22),

        Text(
          'Nothing here. Yet.',
          style: TextStyle(
            fontSize: 17,
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}
