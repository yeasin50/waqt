import 'dart:math';

import 'package:flutter/material.dart';

import '../core/core.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    this.autoFocus = false,
  });

  final TextEditingController controller;

  final bool autoFocus;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  final FocusNode focusNode = FocusNode();

  late PageController pageContoller = InheritedProvider.of<PageController>(
    context,
  );

  void pageListener() {
    assert(widget.autoFocus);

    //TODO: test on release +  check dragEnd and then show
    if (!focusNode.hasFocus && pageContoller.page! > .7) {
      focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    super.initState();
    if (!widget.autoFocus) return;

    // can we we work  with NotificationListener instead
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageContoller.addListener(pageListener);
    });
  }

  late double width = width = MediaQuery.sizeOf(context).width;

  bool isKeyboardOpened = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    width = MediaQuery.sizeOf(context).width;

    final opened = MediaQuery.viewInsetsOf(context).bottom > 0;
    if (isKeyboardOpened != opened) isKeyboardOpened = opened;
    if (focusNode.hasFocus && !isKeyboardOpened) focusNode.unfocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final colors = theme.colorScheme;
    final viewPadding = MediaQuery.viewPaddingOf(context).bottom;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    final decoration = BoxDecoration(
      gradient: LinearGradient(
        begin: .topCenter,
        end: .bottomCenter,
        colors: [colors.surface.withAlpha(10), colors.surface],
      ),
    );
    // dart format off
    return AnimatedPadding(
      duration: .zero,
      padding: .only(bottom: 24 + max(viewPadding, bottomPadding)),
      child: GestureDetector(
        onTap: () {
          final primaryFocus = FocusManager.instance.primaryFocus;
          if (primaryFocus == null) return;

          focusNode.hasFocus
              ? primaryFocus.unfocus()
              : primaryFocus.requestFocus(focusNode);
        },
        child: Container(
          width: width,
          alignment: .center,
          height: 56,
          decoration: decoration,
          child: AnimatedContainer(
            duration: Durations.short3,
            width: (isKeyboardOpened ? .85 : .45) * width,
            height: 48,
            decoration: ShapeDecoration(shape: const StadiumBorder(), color: colors.primaryContainer),
            padding: .symmetric(horizontal: 12),
            child: Stack(
              children: [
                Positioned(
                  left: 8,
                  top: 12,
                  child: Icon(Icons.search, color: colors.onPrimaryContainer),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  top: 10,
                  height: 64,
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: focusNode,
                    cursorColor: colors.primary,
                    cursorHeight: 22,
                    textAlign: .center,
                    textAlignVertical: .center,
                    style: style.bodyLarge?.copyWith(color: colors.onPrimaryContainer),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: style.bodyLarge?.copyWith(
                        color: colors.onPrimaryContainer.withValues(
                          alpha: 0.65,
                        ),
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
