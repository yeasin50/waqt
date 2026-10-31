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
                    color: Colors.yellow, // FIXME: with scheme
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
                  style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 2,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  'Everything, in its time.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.4),
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
