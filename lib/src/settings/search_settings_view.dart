import 'package:flutter/material.dart';

import '../core/core.dart';
import '../widgets/app_checkbox_tile.dart';
import 'widgets/section_builder.dart';

class SearcSettingsView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context).notifier;

    return ListenableBuilder(
      listenable: provider,
      builder: (context, child) {
        final preference = provider.preference;
        final search = preference.search;

        return SectionBuilder(
          label: "Search",
          children: [
            AppCheckboxTile(
              title: "Show search",
              isChecked: search.showSearch,
              onTap: (v) {
                provider.updateSearch(search.copyWith(showSearch: v));
              },
            ),

            AppCheckboxTile(
              title: "Quick search",
              isChecked: search.quickSearch,
              onTap: !search.showSearch
                  ? null
                  : (v) =>
                        provider.updateSearch(search.copyWith(quickSearch: v)),
            ),

            AppCheckboxTile(
              title: "Search at bottom",
              isChecked: search.searchAtBottom,
              onTap: !search.showSearch
                  ? null
                  : (v) => provider.updateSearch(
                      search.copyWith(searchAtBottom: v),
                    ),
            ),

            AppCheckboxTile(
              title: "Automatically open search",
              isChecked: search.autoShowKeyboard,
              onTap: !search.showSearch
                  ? null
                  : (v) => provider.updateSearch(
                      search.copyWith(autoShowKeyboard: v),
                    ),
            ),
          ],
        );
      },
    );
  }
}
