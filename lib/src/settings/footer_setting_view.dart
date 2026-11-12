import 'package:flutter/material.dart';

import '/src/widgets/app_text_update_field.dart';

import '../core/core.dart';
import '../widgets/app_segmented_button_tile.dart';
import 'widgets/section_builder.dart';

class FooterSettingsView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context).notifier;
    final List<String> aligments = ["left", "center", "right"];

    return ListenableBuilder(
      listenable: provider,
      builder: (context, child) {
        final preference = provider.preference;

        return SectionBuilder(
          label: "Footer",
          children: [
            AppTextUpdateField.settingTile(
              title: "left",
              text: preference.footerLeft,
              onTap: () async {
                final result = await AppTextUpdateField.show(
                  context: context,
                  initalText: preference.footerLeft,
                  isBold: true,
                );

                if (result == null) return;
                provider.updatePreference(
                  preference.copyWith(footerLeft: result),
                );
              },
            ),
            AppTextUpdateField.settingTile(
              title: "right",
              text: preference.footerRight,
              onTap: () async {
                final result = await AppTextUpdateField.show(
                  context: context,
                  initalText: preference.footerRight,
                  isBold: false,
                );

                if (result == null) return;
                provider.updatePreference(
                  preference.copyWith(footerRight: result),
                );
              },
            ),
            AppSegmentedButtonTile<String>(
              title: "alignment",
              items: aligments,
              selectedValue: aligments[preference.footerRowAlingment + 1],
              onTap: (v) => provider.updatePreference(
                preference.copyWith(
                  footerRowAlingment: aligments.indexOf(v) - 1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
