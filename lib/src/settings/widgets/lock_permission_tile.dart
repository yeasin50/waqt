import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../widgets/app_checkbox_tile.dart';
import '../../widgets/app_tile.dart';
import 'section_builder.dart';

class LockPermissionTile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context).notifier;
    return ListenableBuilder(
      listenable: provider,
      builder: (context, child) {
        final bool hasLockPermission = provider.hasLockPermission;
        final bool isLockEnabled = provider.preference.enableDoubleTapLock;

        return SectionBuilder(
          label: "Double-Tap Lock",
          onTap: !hasLockPermission ? provider.requestLockPermission : null,
          children: [
            // handled inside SectionBuilder
            if (!hasLockPermission)
              AppTile.setting(title: "Grant permission")
            else
              AppCheckboxTile(
                title: "Enable",
                isChecked: isLockEnabled,
                onTap: provider.toggleDoubleTapLoc,
              ),
          ],
        );
      },
    );
  }
}
