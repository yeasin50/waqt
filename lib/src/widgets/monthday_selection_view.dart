import 'package:flutter/material.dart';

import 'app_chip.dart';
import 'section_title_builder.dart';

/// Make hover-drag selection? Hell NO....
/// Make it difficult to select days to that user think before selecting a day.
class MonthDaySelectionView extends StatelessWidget {
  const MonthDaySelectionView({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  final Set<int> selectedDays;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: 12,
      children: [
        SectionTitleBuilder(title: "month days", onClear: () => onChanged({})),
        GridView.count(
          crossAxisCount: 7,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: List.generate(30, (i) {
            final d = i + 1;
            return AppChip(
              isSelected: selectedDays.contains(d),
              label: d.toString(),
              padding: .zero,
              onTap: () {
                Set<int> updatedValue = selectedDays.toSet();
                updatedValue.contains(d)
                    ? updatedValue.remove(d)
                    : updatedValue.add(d);
                onChanged(updatedValue);
              },
            );
          }),
        ),
      ],
    );
  }
}
