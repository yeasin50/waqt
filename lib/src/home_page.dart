import 'package:flutter/material.dart';

import 'app_list_page.dart';
import 'core/core.dart';
import 'settings/settings_page.dart';
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
          children: [_HomeView(), AppListView()],
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
                    ),
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
