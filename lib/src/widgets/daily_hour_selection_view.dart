import 'package:flutter/material.dart';

import '../core/core.dart';
import 'app_chip.dart';
import 'section_title_builder.dart';

/// List of timeOfDay -> List<start,end> selection view
class DailyHourSelectionView extends StatelessWidget {
  const DailyHourSelectionView({super.key, required this.creator});

  final AppVisibilityCreator creator;

  @override
  Widget build(BuildContext context) {
    final timeStyle = TextTheme.of(context).bodyMedium?.copyWith(
      /// ... Like to have mono fonts
    );

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        SectionTitleBuilder(
          title: "DailyHourSelectionView",
          onClear: creator.clearDayBlocs,
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: .spaceBetween,
          runAlignment: .start,
          children: [
            for (int i = 0; i < creator.numberOfDaySlot; i++)
              () {
                final time = TimeOfDay(hour: i, minute: 0);
                final label =
                    "${(time.hour % 12 == 0 ? 12 : time.hour % 12).toString().padLeft(2, ' ')} ${time.period == .am ? "am" : "pm"}";

                return IntrinsicWidth(
                  child: AppChip(
                    isSelected: creator.isTimeBlocTaken(time),
                    label: label,
                    onTap: () => creator.toggleDayBloc(time),
                    labelStyle: timeStyle,
                  ),
                );
              }(),
          ],
        ),
      ],
    );
  }
}
