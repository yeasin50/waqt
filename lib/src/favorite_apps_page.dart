import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'core/core.dart';
import 'widgets/animated_list_item.dart';
import 'widgets/app_tile.dart';

/// user config their home page apps
class FavoriteAppsPage extends StatefulWidget {
  const new({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute(builder: (context) => FavoriteAppsPage());
  }

  @override
  State<FavoriteAppsPage> createState() => _FavoriteAppsPageState();
}

class _FavoriteAppsPageState extends State<FavoriteAppsPage> {
  final _listKey = GlobalKey<SliverAnimatedListState>();

  late List<AppInfo> apps = [];
  late ListModel<AppInfo> _list;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      final provider = AppProvider.of(context).notifier;
      apps = provider.apps.where((e) => !e.isFavtorite).toList();
      _list = ListModel<AppInfo>(
        listKey: _listKey,
        initialItems: apps.toList(),
        removedItemBuilder: _buildRemovedItem,
      );
      setState(() {});
    });
  }

  Widget _buildRemovedItem(AppInfo item, context, animation) =>
      AppTile(animation: animation, title: item.name, onTap: null);

  Widget _buildItem(context, int index, Animation<double> animation) {
    return AppTile(
      animation: animation,
      title: _list[index].name,
      onTap: () {
        final provider = AppProvider.of(context).notifier;
        _list.removeAt(index);
        provider.toggleFavorite(apps[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                scrolledUnderElevation: 0,
              ),
              _FavoriteApps(),
              SliverMainAxisGroup(
                slivers: [
                  SliverToBoxAdapter(child: Text("Other apps")),
                  if (apps.isNotEmpty)
                    SliverAnimatedList(
                      key: _listKey,
                      initialItemCount: _list.length,
                      itemBuilder: _buildItem,
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
