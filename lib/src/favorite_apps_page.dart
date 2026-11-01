import 'dart:ui';

import 'package:flutter/material.dart';

import 'core/core.dart';
import 'widgets/app_tile.dart';

class FavoriteAppsPage extends StatelessWidget {
  const new({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      builder: (context) {
        return FavoriteAppsPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    late final provider = AppProvider.of(context).notifier;

    final style = TextTheme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                pinned: true,
                title: Text("Home apps", style: style.bodyLarge),
              ),
              _FavoriteApps(),
              SliverList.list(
                children: [
                  Text("Other apps"),
                  ListenableBuilder(
                    listenable: provider,
                    builder: (context, child) => Column(
                      children: <Widget>[
                        for (final app in provider.apps.where(
                          (e) => !e.isFavtorite,
                        ))
                          AppTile(
                            title: app.name,
                            onTap: () => provider.toggleFavorite(app),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late final provider = AppProvider.of(context).notifier;

    final style = TextTheme.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color draggableItemColor = colorScheme.secondary;

    Widget proxyDecorator(
      Widget child,
      int index,
      Animation<double> animation,
    ) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;
          return Material(
            elevation: elevation,
            color: draggableItemColor,
            shadowColor: draggableItemColor,
            child: child,
          );
        },
        child: child,
      );
    }

    return ListenableBuilder(
      listenable: provider,
      builder: (context, child) {
        late List<AppInfo> favoriteApps = provider.favoriteApps.toList();
        String adviceText = favoriteApps.length > 4
            ? "Protect your focus. Keep only what truly matters, remove others."
            : "";
        return SliverMainAxisGroup(
          slivers: [
            SliverReorderableList(
              proxyDecorator: proxyDecorator,
              itemCount: favoriteApps.length,
              onReorderItem: provider.reOrderFavotireApp,
              itemBuilder: (context, index) {
                final app = favoriteApps[index];
                return AppTile(
                  key: Key(app.packageName),
                  title: app.name,
                  onTap: () {
                    provider.toggleFavorite(app, false);
                  },
                  tralling: ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.drag_handle_outlined),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 64,
                child: Center(
                  child: Text(
                    adviceText,
                    textAlign: .center,
                    style: style.bodyMedium?.copyWith(
                      fontStyle: .italic,
                      color: colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
