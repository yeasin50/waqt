import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onTap,
    this.padding = const .symmetric(horizontal: 12.0, vertical: 8),
  });

  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Material(
      shape: StadiumBorder(),
      color: isSelected ? color.surfaceTint.withValues(alpha: .3) : null,
      child: InkWell(
        customBorder: StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Center(child: Text(label)),
        ),
      ),
    );
  }
}
