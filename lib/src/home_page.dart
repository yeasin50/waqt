import 'package:flutter/material.dart';

import 'core/core.dart';
import 'settings/settings_page.dart';
import 'widgets/app_option_bottom_sheet.dart';
import 'widgets/app_search_field.dart';
import 'widgets/app_tile.dart';
import 'widgets/clock_view.dart';
import 'widgets/favorite_app_list.dart';
import 'widgets/footer_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController controller = PageController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: InheritedProvider<PageController>(
        notifier: controller,
        child: PageView(
          physics: const BouncingScrollPhysics(),
          controller: controller,
          onPageChanged: (page) {
            if (page == 0) FocusManager.instance.primaryFocus?.unfocus();
          },
          children: [_HomeView(), _AppListView()],
        ),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: AppProvider.of(context).notifier,
        builder: (context, child) {
          final provider = AppProvider.of(context).notifier;
          return GestureDetector(
            behavior: .opaque,
            onDoubleTap: provider.lockScreen,
            onLongPress: () {
              Navigator.of(context).push(SettingsPage.route());
            },
            child: Padding(
              padding: const .all(24.0),
              child: Column(
                crossAxisAlignment: .stretch,
                spacing: 16,
                children: [
                  Expanded(
                    flex: 4,
                    child: Align(alignment: .centerLeft, child: ClockView()),
                  ),

                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment(0, -.1),
                      child: SingleChildScrollView(child: FavoriteAppList()),
                    ), // I may  limit only to 5
                  ),
                  Align(alignment: .bottomCenter, child: FooterView()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AppListView extends StatefulWidget {
  const new();

  @override
  State<_AppListView> createState() => _AppListViewState();
}

class _AppListViewState extends State<_AppListView> {
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppProvider.of(context).notifier,
      builder: (context, child) {
        final provider = AppProvider.of(context).notifier;

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
    ;
  }
}
