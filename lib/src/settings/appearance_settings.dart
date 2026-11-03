import 'package:flutter/material.dart';

import '../core/core.dart';
import '../widgets/app_checkbox_tile.dart';
import '../widgets/app_segmented_button_tile.dart';
import 'widgets/section_builder.dart';

class AppearanceSettings extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> aligments = ["left", "center", "right"];

    final provider = AppProvider.of(context).notifier;

    return ListenableBuilder(
      listenable: provider,
      builder: (context, child) {
        final preference = provider.preference;
        final appearance = preference.appearance;

        // final String language;
        // final String theme;
        // final bool useSystemFont;
        // final String customFont;
        // final int itemSpacing;
        // final int fontSize;
        // // Clock
        // final bool isLargeClock;
        // // App list

        return SectionBuilder(
          label: "Appearance",
          children: [
            AppCheckboxTile(
              title: "Show status bar",
              isChecked: appearance.showStatusBar,
              onTap: (v) {
                final bg = Theme.of(context).scaffoldBackgroundColor;
                provider.toggleStatusBar(scaffoldBG: bg, show: v);
              },
            ),
            AppCheckboxTile(
              title: "show clock",
              isChecked: appearance.showClock,
              onTap: (v) {
                AppProvider.of(context).notifier.updatePreference(
                  provider.preference.copyWith(
                    appearance: provider.preference.appearance.copyWith(
                      showClock: v,
                    ),
                  ),
                );
              },
            ),

            AppCheckboxTile(
              title: "show Date",
              isChecked: appearance.showDate,
              onTap: appearance.showClock == false
                  ? null
                  : (v) => provider.updateAppearance(showDate: v),
            ),

            AppSegmentedButtonTile<String>(
              title: "clock alignment",
              items: aligments,
              selectedValue: aligments[appearance.clockAlignment + 1],
              onTap: appearance.showClock == false
                  ? null
                  : (v) => provider.updateAppearance(
                      clockAlignment: aligments.indexOf(v) - 1,
                    ),
            ),
          ],
        );
      },
    );
  }
}
