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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                // title: Text("Favorite app" ),
              ),
              _FavoriteApps(),
              SliverList.list(
                children: [
                  SizedBox(height: 48),
                  Divider(),
                  Text("other apps"),
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
        return SliverReorderableList(
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
        );
      },
    );
  }
}
