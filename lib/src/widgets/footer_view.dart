import 'package:flutter/material.dart';

import '../core/core.dart' show AppProvider;
import '../debug_screen.dart';

class FooterView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ColorScheme.of(context);
    final style = TextTheme.of(context);

    return ListenableBuilder(
      listenable: AppProvider.of(context).notifier,
      builder: (context, child) {
        final provider = AppProvider.of(context).notifier;
        return Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          spacing: 8,
          children: [
            if (provider.err.isNotEmpty)
              TextButton(
                onPressed: () {
                  provider.handleError();
                  Navigator.of(context).push(DebugScreen.route());
                },
                child: Text(
                  provider.err,
                  textAlign: .center,
                  style: style.bodyMedium?.copyWith(
                    color: color.error,
                    fontStyle: .italic,
                  ),
                ),
              ),

            if (!provider.isDefaultLauncher)
              ElevatedButton(
                onPressed: provider.requestDefaultLauncher,
                child: Text(
                  "Set Default & Stay Focused",
                  textAlign: .center,
                  style: style.bodyMedium?.copyWith(
                    color: color.tertiary,
                    fontStyle: .italic,
                  ),
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'waqt',
                  style: style.titleMedium?.copyWith(
                    letterSpacing: 2,
                    color: color.onSurface,
                  ),
                ),
                Text(
                  'Everything, in its time.',
                  style: style.bodySmall?.copyWith(
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
