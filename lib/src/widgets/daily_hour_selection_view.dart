import 'package:flutter/material.dart';

import '../app_visiblity_config_page.dart';

/// List of timeOfDay -> List<start,end> selection view
class DailyHourSelectionView extends StatelessWidget {
  const DailyHourSelectionView({super.key, required this.creator});

  final AppVisiblityCreator creator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text("DailyHourSelectionView"),
        SizedBox(height: 12),

        for (int i = 0; i < creator.dailyTime.length; i++)
          DailyScheduleView(
            start: creator.dailyTime[i].$1,
            end: creator.dailyTime[i].$2,
            onChanged: (start, end) {
              creator.updateTimeOfDay(i, start, end);
            },
          ),

        DailyScheduleView(
          start: TimeOfDay(hour: 0, minute: 0),
          end: TimeOfDay(hour: 0, minute: 0),
          onChanged: (start, end) {
            // selectedHours.add((start, end));
            // onUpdate(selectedHours);
            print("$start $end");
          },
        ),
      ],
    );
  }
}

///TODO:  I still don;t like the idea time picker,
/// Perhaps gonna use grid but how should I represent I am  still in double
/// [ morning,afternoon,night....] N Column with  X interval time?
class DailyScheduleView extends StatelessWidget {
  const DailyScheduleView({
    super.key,
    required this.start,
    required this.end,
    required this.onChanged,
    this.onRemove,
  });

  final TimeOfDay start;
  final TimeOfDay end;
  final Function(TimeOfDay start, TimeOfDay end) onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    Widget buildTime(bool isStart) {
      final time = isStart ? start : end;
      final label =
          "${time.hour % 12}:${time.minute}${time.period == .am ? "am" : "pm"}";

      return InkWell(
        onTap: () async {
          final result = await showTimePicker(
            context: context,
            initialTime: isStart ? start : end,
          );
          if (result == null) return;
          onChanged(isStart ? result : start, !isStart ? result : end);
        },
        child: Padding(
          padding: const .symmetric(horizontal: 12.0, vertical: 8),
          child: Text(label),
        ),
      );
    }

    return Row(
      spacing: 12,
      children: [
        buildTime(true),
        Text("to"),
        buildTime(false),
        if (start != end) InkWell(onTap: onRemove, child: Icon(Icons.close)),
      ],
    );
  }
}
