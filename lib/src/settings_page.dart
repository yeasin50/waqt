import 'package:flutter/material.dart';

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

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
