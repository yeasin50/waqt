import 'package:flutter/material.dart';

import 'core/core.dart';
import 'widgets/daily_hour_selection_view.dart';
import 'widgets/monthday_selection_view.dart';
import 'widgets/weekday_selection_view.dart';

//TODO:  color map  per day*time for progress graph

class AppVisiblityConfigPage extends StatefulWidget {
  const new({super.key, required this.appInfo});

  final AppInfo appInfo;

  static MaterialPageRoute route(AppInfo app, AppNotifier notifier) {
    return MaterialPageRoute(
      builder: (context) => AppProvider(
        notifier: notifier,
        child: AppVisiblityConfigPage(appInfo: app),
      ),
    );
  }

  @override
  State<AppVisiblityConfigPage> createState() => _AppVisiblityConfigPageState();
}

class _AppVisiblityConfigPageState extends State<AppVisiblityConfigPage> {
  late final AppVisiblityCreator creator = AppVisiblityCreator(
    widget.appInfo.visiblityInfo,
  );

  @override
  void initState() {
    super.initState();
    print(widget.appInfo.visiblityInfo.toString());
  }

  void save() {
    AppProvider.of(context).notifier
        .updateVibilityConfig(creator.toSaveModel(widget.appInfo.packageName));
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).copyWith(
        segmentedButtonTheme: SegmentedButtonThemeData(
          selectedIcon: SizedBox(),
          style: SegmentedButton.styleFrom(
            selectedForegroundColor: color.onPrimaryContainer,
            selectedBackgroundColor: color.primaryContainer,
            fixedSize: const Size(100, 40),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: save, icon: Icon(Icons.save))],
        ),
        body: ListenableBuilder(
          listenable: creator,

          builder: (context, child) => SingleChildScrollView(
            padding: const .symmetric(horizontal: 24.0),
            child: Column(
              spacing: 12,
              crossAxisAlignment: .stretch,
              children: [
                Text("${widget.appInfo.name} visibility"),
                Align(
                  alignment: .centerLeft,
                  child: SegmentedButton<AppVisiblityMode>(
                    multiSelectionEnabled: false,
                    emptySelectionAllowed: true,
                    selected: {creator.selectedMode},
                    onSelectionChanged: (v) => creator.changeMode(v.first),
                    segments: AppVisiblityMode.values
                        .map(
                          (e) => ButtonSegment(value: e, label: Text(e.name)),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 24,
                  child: Placeholder(child: Text("12 h of 24h")),
                ),

                SizedBox(height: 8),

                /// Week days
                if (creator.selectedMode == .weekly)
                  WeekDaySelectionView(
                    selectedDay: creator.selectedWeekDays,
                    onChanged: creator.updateWeekDays,
                  )
                else if (creator.selectedMode == .monthly)
                  MonthDaySelectionView(
                    selectedDays: creator.selectedMonthDays,
                    onChanged: (v) => creator.updateMonthDays(v),
                  ),

                if (creator.selectedMode != .always)
                  DailyHourSelectionView(creator: creator),

                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
