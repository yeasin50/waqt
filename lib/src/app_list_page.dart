import 'package:flutter/material.dart';
import 'package:waqt/src/core/core.dart';

import 'settings/settings_page.dart';
import 'widgets/app_option_bottom_sheet.dart';
import 'widgets/app_search_field.dart';
import 'widgets/app_tile.dart';

class AppListView extends StatefulWidget {
  const new({super.key});

  @override
  State<AppListView> createState() => _AppListViewState();
}

class _AppListViewState extends State<AppListView> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      AppProvider.of(context).notifier.onSearch(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  late final provider = AppProvider.of(context).notifier;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: provider,
      builder: (context, child) {
        final searchPref = provider.preference.search;

        return Scaffold(
          floatingActionButtonLocation: searchPref.searchAtBottom
              ? .centerDocked
              : .startTop,
          floatingActionButton: searchPref.showSearch
              ? AppSearchField(
                  controller: searchController,
                  autoFocus: searchPref.autoShowKeyboard,
                )
              : null,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverList.list(
                  children: [
                    _AppListHeaderView(),

                    Column(
                      children: [
                        ...provider.filteredApps.map(
                          (app) => AppTile(
                            title: app.name,
                            onTap: () {
                              provider.launchApp(app);
                              searchController.clear();
                              // unFocuse again?
                            },
                            onLongPress: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              AppOptionBottomSheet.show(
                                context: context,
                                appInfo: app,
                                provider: provider,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 96 + 24),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AppListHeaderView extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Align(
        alignment: Alignment(0, .25),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            SizedBox(width: 48),
            Text(
              "All Apps",
              style: TextTheme.of(context).headlineMedium?.copyWith(),
              textAlign: .center,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(SettingsPage.route());
              },
              icon: Icon(Icons.settings_outlined),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
