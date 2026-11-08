import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_list_page.dart';
import 'core/core.dart';
import 'settings/settings_page.dart';
import 'widget_picker_page.dart';
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
      behavior: .translucent,
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
      extendBodyBehindAppBar: true,
      //TODO: remove after fixing colorScheme
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final route = ColorSchemeView.route(ColorScheme.of(context));
          // Navigator.of(context).push(route);
        },
      ),
      body: ListenableBuilder(
        listenable: AppProvider.of(context).notifier,
        builder: (context, child) {
          final provider = AppProvider.of(context).notifier;
          final appearance = provider.preference.appearance;
          final clockAlignment = appearance.clockAlignment.toDouble();

          return SafeArea(
            child: GestureDetector(
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
                      child: Align(
                        alignment: Alignment(clockAlignment, 0),
                        child: appearance.showClock
                            ? ClockView(showDate: appearance.showDate)
                            : SizedBox.shrink(), //TODO: I would rather not depends on flex to show [FavoriteAppList]
                      ),
                    ),

                    _HomeWidgetPrevew(),

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
            ),
          );
        },
      ),
    );
  }
}

class _HomeWidgetPrevew extends StatefulWidget {
  const new({super.key});

  @override
  State<_HomeWidgetPrevew> createState() => _HomeWidgetPrevewState();
}

class _HomeWidgetPrevewState extends State<_HomeWidgetPrevew> {
  int? widgetId;

  void pickWidget() async {
    final pickedWidget = await WidgetPickerPage.show(context);
    if (pickedWidget == null || !context.mounted) return;

    final api = AppProvider.of(context).notifier.appManagerApi;
    widgetId = await api.addWidget(
      pickedWidget.packageName,
      pickedWidget.className,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickWidget,
      child: Column(
        mainAxisSize: .min,
        children: [
          if (widgetId == null)
            Icon(Icons.widgets)
          else
            SizedBox(
              height: 120,
              child: AndroidView(
                viewType: 'native_app_widget',
                creationParams: {'widgetId': widgetId},
                creationParamsCodec: const StandardMessageCodec(),
              ),
            ),
        ],
      ),
    );
  }
}
