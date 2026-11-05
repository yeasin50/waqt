import 'package:flutter/material.dart';

class ColorPickerRow extends StatelessWidget {
  const new({
    super.key,

    required this.brightness,
    required this.selectedColor,
    required this.onTap,
    required this.colors,
  });

  final Brightness brightness;
  final Color selectedColor;
  final List<Color> colors; // 4/5 at most
  final Function(Brightness, Color) onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = brightness == .dark;
    return Row(
      spacing: 8,
      children: [
        IconButton(
          onPressed: () => onTap(isDark ? .light : .dark, selectedColor),
          icon: Icon(isDark ? Icons.light_sharp : Icons.dark_mode_sharp),
        ),

        Row(
          spacing: 8,
          children: [
            ...colors.map(
              (e) => SizedBox.square(
                dimension: 40,
                child: GestureDetector(
                  onTap: () => onTap(brightness, e),
                  child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: e == selectedColor
                            ? ColorScheme.of(context).surfaceTint
                            : Colors.transparent,
                      ),
                    ),
                    child: Padding(
                      padding: .all(6),
                      child: Material(color: e, shape: CircleBorder()),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
