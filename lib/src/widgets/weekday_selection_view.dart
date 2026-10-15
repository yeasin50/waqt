import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'app_chip.dart';
import 'section_title_builder.dart';

class WeekDaySelectionView extends StatelessWidget {
  const WeekDaySelectionView({
    super.key,
    required this.selectedDay,
    required this.onChanged,
  });

  final Set<int> selectedDay;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: 12,
      children: [
        SectionTitleBuilder(title: "week days", onClear: () => onChanged({})),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"].mapIndexed(
              (i, e) => IntrinsicWidth(
                child: AppChip(
                  isSelected: selectedDay.contains(i),
                  label: e,
                  onTap: () {
                    Set<int> updatedValue = selectedDay.toSet();
                    updatedValue.contains(i)
                        ? updatedValue.remove(i)
                        : updatedValue.add(i);
                    onChanged(updatedValue);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
