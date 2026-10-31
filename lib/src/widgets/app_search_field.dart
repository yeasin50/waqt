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

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final theme = Theme.of(context);
    final style = theme.textTheme;

    final isKeyboardOpened = MediaQuery.viewInsetsOf(context).bottom > 0;

    print("rebuild"); //TODO: check  why  3x rebuilds
    return GestureDetector(
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
        height: 96 + 24,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: .topCenter,
            end: .bottomCenter,
            colors: [Colors.transparent, theme.scaffoldBackgroundColor],
          ),
        ),
        child: Padding(
          padding: const .all(24.0),
          child: AnimatedContainer(
            duration: Durations.short3,
            width: (isKeyboardOpened ? .85 : .45) * width,
            height: 48,
            decoration: ShapeDecoration(
              shape: StadiumBorder(),
              color: theme.colorScheme.primaryContainer,
            ),
            padding: .symmetric(horizontal: 12),
            child: Stack(
              children: [
                Positioned(
                  left: 8,
                  top: 12,
                  child: const Icon(Icons.search, color: Colors.black87),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 0,
                  top: 10,
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: focusNode,
                    cursorColor: Colors.grey,
                    cursorHeight: 22,
                    textAlign: .center,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: style.bodyLarge?.copyWith(
                        color: Colors.black87,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    style: style.bodyLarge?.copyWith(color: Colors.black),
                    textAlignVertical: .center,
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
