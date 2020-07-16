import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_title.dart';

class FiltersPanel extends StatefulWidget {
  final List<Filter> initialFilters;
  final List<Filter> currentFilters;
  final Function() reset;
  final Function(List<Filter>) update;
  final Function() apply;

  const FiltersPanel(
      {Key key,
      this.initialFilters,
      this.reset,
      this.update,
      this.currentFilters,
      this.apply})
      : super(key: key);

  @override
  _FiltersPanelState createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<FiltersPanel> {
  List<Filter> modifiedFilters;

  initState() {
    modifiedFilters = widget.currentFilters;

    super.initState();
  }

  updateFilters(Filter filter) {
    final oldModifiedIndex = modifiedFilters
        .indexWhere((oldFilter) => oldFilter.name == filter.name);

    final initialValues = widget.initialFilters
        .firstWhere((oldFilter) => oldFilter.name == filter.name)
        .values;

    setState(() {
      if (oldModifiedIndex >= 0) modifiedFilters.removeAt(oldModifiedIndex);

      if (filter.values.isNotEmpty && filter.values != initialValues)
        modifiedFilters.add(filter);
    });

    if (modifiedFilters.isNotEmpty && widget.update != null)
      widget.update(modifiedFilters);
  }

  getModified(Filter filter) {
    if (filter.name == "Размер")
      print(modifiedFilters.firstWhere(
          (modified) => modified.name == filter.name,
          orElse: () => null));
    return modifiedFilters.firstWhere(
        (modified) => modified.name == filter.name,
        orElse: () => null);
  }

  resetFilters() {
    setState(() {
      modifiedFilters.clear();
    });

    if (widget.reset != null) widget.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Material(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FiltersTitle(
                  onReset: resetFilters,
                  filtersChanged: modifiedFilters.isNotEmpty,
                ),
              ]..addAll(
                  widget.initialFilters.asMap().entries.map((entry) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (entry.key != 0) CategoryDivider(),
                          FilterTile(
                              original: entry.value,
                              modified: getModified(entry.value),
                              onChange: updateFilters),
                        ],
                      ))),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomButton(
            action: () {
              Navigator.of(context).pop();
              widget.apply();
            },
            title: "ПОКАЗАТЬ",
            subtitle: "5083 товара",
          ),
        )
      ],
    );
  }
}
