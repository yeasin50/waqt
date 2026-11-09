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
  final List<Color> colors;
  final Function(Brightness, Color) onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = brightness == .dark;

    return Row(
      spacing: 8,
      children: [
        IconButton(
          onPressed: () => onTap(isDark ? .light : .dark, selectedColor),
          icon: Icon(isDark ? Icons.light_mode_sharp : Icons.dark_mode_sharp),
        ),

        Expanded(
          child: SingleChildScrollView(
            scrollDirection: .horizontal,
            child: Row(
              spacing: 8,
              children: [
                ...colors.map((e) {
                  // dart format off
                  final shape = e == selectedColor
                      ? CircleBorder(side: .new(color: ColorScheme.of(context).surfaceTint))
                      : null;
                  return SizedBox.square(
                    dimension: 40,
                    child: GestureDetector(
                      onTap: () => onTap(brightness, e),
                      child: Material(
                        color: Colors.transparent,
                        shape: shape,
                        child: Padding(
                          padding: .all(6),
                          child: Material(color: e, shape: CircleBorder()),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
