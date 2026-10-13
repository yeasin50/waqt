import 'package:flutter/material.dart';

/// List of timeOfDay -> List<start,end> selection view
class DailyHourSelectionView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text("DailyHourSelectionView"),

        /// ... TODO: some list of time stuff,
        /// Row(start,end,deleteIcong)
      ],
    );
  }
}
