import 'package:flutter/material.dart';

import 'app_service.dart';
import 'widgets/app_option_bottom_sheet.dart';
import 'widgets/app_search_field.dart';
import 'widgets/app_tile.dart';
import 'widgets/clock_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final service = AppService();

  @override
  void initState() {
    super.initState();
    service.getInstalledApps();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AppProvider(
        service: service,
        child: PageView(
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
  const new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const .all(24.0),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const Spacer(flex: 1),
            ClockView(),
            const Spacer(flex: 3),

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

            const Spacer(flex: 2),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'waqt',
                  style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 2,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  'Everything, in its time.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ],
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
  late final provider = AppProvider.of(context).service;
  late List<AppInfo> filteredApps = provider.apps;

  void onSearch(String v) {
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
  Widget build(BuildContext context) {
    final style = TextTheme.of(context);

    return Scaffold(
      floatingActionButtonLocation: .centerDocked, //TODO: might create custom location or might convert into stack
      floatingActionButton: AppSearchField(onChanged: onSearch),
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
                          onPressed: () {},
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
                    onTap: () => provider.launchApp(app),
                    onLongPress: () => AppOptionBottomSheet.show(
                      context: context,
                      appInfo: app,
                      service: provider,
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
