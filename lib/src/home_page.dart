import 'package:flutter/material.dart';

import 'app_service.dart';
import 'widgets/app_search_field.dart';
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
      child: PageView(
        onPageChanged: (page) {
          if (page == 0) FocusManager.instance.primaryFocus?.unfocus();
        },
        children: [
          _HomeView(),
          _AppListView(service: service),
        ],
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
  const new({required this.service});

  final AppService service;

  @override
  State<_AppListView> createState() => _AppListViewState();
}

class _AppListViewState extends State<_AppListView> {
  late List<AppInfo> filteredApps = widget.service.apps;

  void onSearch(String v) {
    if (v.trim().isEmpty) {
      filteredApps = widget.service.apps;
    } else {
      filteredApps = widget.service.apps
          .where((e) => e.name.toLowerCase().contains(v.toLowerCase()))
          .toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context);

    return Scaffold(
      floatingActionButtonLocation:
          .centerDocked, //TODO: might create custom location
      floatingActionButton: AppSearchField(onChanged: onSearch),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                SizedBox(
                  height: 75,
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      SizedBox(width: 48),
                      Text(
                        "All Apps",
                        style: style.bodyLarge?.copyWith(),
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
                ...filteredApps.map(
                  (app) => InkWell(
                    onTap: () => widget.service.launchApp(app),
                    child: Padding(
                      padding: const .all(12.0),
                      child: Text(
                        app.name,
                        textAlign: .center,
                        style: style.bodyLarge?.copyWith(),
                      ),
                    ),
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
