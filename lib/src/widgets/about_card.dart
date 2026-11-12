import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ColorScheme.of(context);

    final border = RoundedRectangleBorder(borderRadius: .circular(16));

    final style = TextTheme.of(context);

    final String name = "Waqt";
    final String version = "VERSION 0.1.0";
    final String qoute =
        "You can't make more time,\nbut you can make better use of it.";
    final String supportText = "Support Waqt";

    void onSupport() {
      final String supportLink = "https://github.com/yeasin50/waqt";
      launchUrl(Uri.parse(supportLink));
    }

    return Padding(
      padding: const .all(16.0),
      child: Material(
        color: color.surfaceContainerLowest,
        shape: border,
        child: InkWell(
          onTap: null,
          customBorder: border,
          child: Padding(
            padding: const .all(24),
            child: Column(
              mainAxisSize: .min,
              spacing: 16,
              children: [
                SizedBox.square(
                  dimension: 88,
                  child: ClipRRect(
                    borderRadius: .circular(24),
                    child: Placeholder(), //TODO: logo
                  ),
                ),

                Column(
                  children: [
                    Text(
                      name,
                      style: style.headlineSmall?.copyWith(
                        fontWeight: .w500,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      version,
                      style: style.labelSmall?.copyWith(
                        color: style.bodySmall?.color?.withValues(alpha: 0.6),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),

                Text(
                  qoute,
                  textAlign: .center,
                  style: style.titleMedium?.copyWith(
                    height: 1.5,
                    fontWeight: .w400,
                  ),
                ),

                FilledButton.tonalIcon(
                  onPressed: onSupport,
                  icon: const Icon(Icons.favorite_rounded, size: 18),
                  label: Text(supportText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
