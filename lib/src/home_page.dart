import 'package:flutter/material.dart';

import 'core/core.dart';
import 'settings_page.dart';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: PageView(
        physics: const BouncingScrollPhysics(),
        onPageChanged: (page) {
          if (page == 0) FocusManager.instance.primaryFocus?.unfocus();
        },
        children: [_HomeView(), _AppListView()],
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        //Find: why  I need to have  it here -_-, Because I already  have ListenableBuilder inside FavoriteAppList
        listenable: AppProvider.of(context).notifier,
        builder: (context, child) => Padding(
          padding: const .all(24.0),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              const Spacer(flex: 1),
              ClockView(),
              const Spacer(flex: 3),

              FavoriteAppList(), //TODO: fixed size %height
              const Spacer(flex: 2),
              FooterView(),
            ],
          ),
        ),
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
  late final provider = AppProvider.of(context).notifier;
  late List<AppInfo> filteredApps = provider.apps;

  final searchController = TextEditingController();

  void onSearch() {
    final v = searchController.text;
    if (v.trim().isEmpty) {
      filteredApps = provider.apps;
    } else {
      filteredApps = provider.apps
          .where((e) => e.name.toLowerCase().contains(v.toLowerCase()))
          .toList();
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearch);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context);

    return Scaffold(
      floatingActionButtonLocation: .centerDocked, //TODO: might create custom location or might convert into stack
      floatingActionButton: AppSearchField(controller: searchController),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                SizedBox(
                  height: 220,
                  child: Align(
                    alignment: Alignment(0, .25),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        SizedBox(width: 48),
                        Text(
                          "All Apps",
                          style: style.headlineMedium?.copyWith(),
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
                ),
                ...filteredApps.map(
                  (app) => AppTile(
                    title: app.name,
                    onTap: () {
                      provider.launchApp(app);
                      searchController.clear();
                      // unFocuse again?
                    },
                    onLongPress: () => AppOptionBottomSheet.show(
                      context: context,
                      appInfo: app,
                      provider: provider,
                    ),
                  ),
                ),

                SizedBox(height: 96 + 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
