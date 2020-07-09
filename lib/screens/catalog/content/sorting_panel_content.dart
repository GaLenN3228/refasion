import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/components/filters_top_panel.dart';
import 'package:refashioned_app/screens/catalog/components/measure_size.dart';
import 'package:refashioned_app/screens/catalog/components/sort_method_tile.dart';

class SortingPanelContent extends StatefulWidget {
  final List<String> methods;
  final int initialSelected;
  final Function(int) onSelect;
  final Function(Size) onBuild;

  const SortingPanelContent(
      {Key key,
      this.methods,
      this.onSelect,
      this.initialSelected,
      this.onBuild})
      : super(key: key);

  @override
  _SortingPanelContentState createState() => _SortingPanelContentState();
}

class _SortingPanelContentState extends State<SortingPanelContent> {
  int selectedIndex = 0;
  final widgetKey = GlobalKey();

  @override
  initState() {
    selectedIndex = widget.initialSelected;
    super.initState();
  }

  selectIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onSelect(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MeasureSize(
          onChange: (size) => widget.onBuild(size),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FiltersTopPanel(
                type: PanelType.sorting,
              ),
            ]..addAll(widget.methods.asMap().entries.map((e) => Column(
                  children: [
                    if (e.key != 0) CategoryDivider(),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => selectIndex(e.key),
                        child: SortMethodTile(
                            method: e.value, selected: e.key == selectedIndex)),
                  ],
                ))),
          ),
        ),
        Expanded(
          child: SizedBox(),
        )
      ],
    );
  }
}
