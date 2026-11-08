import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waqt/src/core/core.dart';

import 'core/services/apps_api.g.dart';

class WidgetPickerPage extends StatefulWidget {
  const new({super.key});

  /// whaterver returns add to homePage
  static Future<InstalledWidget?> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return WidgetPickerPage();
      },
    );
  }

  @override
  State<WidgetPickerPage> createState() => _WidgetPickerPageState();
}

class _WidgetPickerPageState extends State<WidgetPickerPage> {
  int? widgetId;

  Future<List<InstalledWidget>> loadPreview() async {
    late final api = AppProvider.of(context).notifier.appManagerApi;
    final List<InstalledWidget> result = await api.getInstalledWidgets();
    return result;
  }

  late Future<List<InstalledWidget>> future = loadPreview();

  Set<int> expandedIndex = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InstalledWidget>>(
      future: future,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == .waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (asyncSnapshot.hasData == false)
          return Center(child: CircularProgressIndicator());

        final widgets = asyncSnapshot.data!;
        final pkgWidgets = groupBy(widgets, (e) => e.packageName);

        return SafeArea(
          child: SingleChildScrollView(
            child: ExpansionPanelList(
              expandedHeaderPadding: .symmetric(horizontal: 16, vertical: 6),
              expansionCallback: (index, isExpanded) {
                if (expandedIndex.contains(index)) {
                  expandedIndex.remove(index);
                } else {
                  expandedIndex.add(index);
                }

                setState(() {});
              },
              children: [
                for (int i = 0; i < pkgWidgets.keys.length; i++)
                  () {
                    final pkg = pkgWidgets.keys.elementAt(i);
                    final widgets = pkgWidgets[pkg]!;
                    final total = widgets.length.toString();

                    return ExpansionPanel(
                      isExpanded: expandedIndex.contains(i),
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) {
                        final item = pkgWidgets[pkg]!.first;
                        final label =
                            "${item.packageName.split(".").last} ($total)";

                        return Row(
                          spacing: 8,
                          children: [
                            if (item.icon != null)
                              Image.memory(item.icon!, width: 32, height: 32),
                            Text(label),
                          ],
                        );
                      },
                      body: Column(
                        crossAxisAlignment: .stretch,
                        spacing: 12,

                        children: [
                          for (final w in widgets)
                            InkWell(
                              onTap: () => Navigator.of(context).pop(w),
                              child: Row(
                                spacing: 8,
                                children: [
                                  Image.memory(
                                    w.previewImage ?? w.icon ?? Uint8List(0),
                                    height: 56,
                                    errorBuilder: (_, _, _) {
                                      return Icon(Icons.error);
                                    },
                                  ),

                                  Expanded(child: Text(w.label)),

                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  }(),
              ],
            ),
          ),
        );
      },
    );
  }
}
