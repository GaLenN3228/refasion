import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/components/tile_of_selectable_list.dart';

class SelectableList extends StatefulWidget {
  final Map<String, bool> initialData;
  final Function(List<String>) onUpdate;
  final Function(String) onSelect;
  final bool multiSelection;
  final bool horizontal;
  final double horizontalHeight;
  final EdgeInsets padding;

  const SelectableList(
      {Key key,
      this.initialData,
      this.onUpdate,
      this.multiSelection: true,
      this.onSelect,
      this.horizontal: false,
      this.horizontalHeight: 30.0,
      this.padding})
      : super(key: key);
  @override
  _SelectableListState createState() => _SelectableListState();
}

class _SelectableListState extends State<SelectableList> {
  Map<String, bool> data;

  @override
  void initState() {
    data = widget.initialData;
    super.initState();
  }

  onSelect(String selectedValue) {
    if (widget.multiSelection) {
      setState(() {
        data[selectedValue] = !data[selectedValue];
      });

      final selectedData = data.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      widget.onUpdate(selectedData);
    } else {
      final newData = data.map((key, _) => MapEntry(key, key == selectedValue));

      setState(() {
        data = newData;
      });

      widget.onSelect(selectedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.horizontal ? widget.horizontalHeight : 0.0,
      child: ListView.separated(
        scrollDirection: widget.horizontal ? Axis.horizontal : Axis.vertical,
        itemCount: data.entries.length,
        padding: widget.padding ?? EdgeInsets.zero,
        itemBuilder: (context, index) {
          return TileOfSelectableList(
            horizontal: widget.horizontal,
            horizontalHeight: widget.horizontalHeight,
            data: data.entries.elementAt(index),
            onSelect: onSelect,
          );
        },
        separatorBuilder: (context, index) {
          if (widget.horizontal)
            return SizedBox(
              width: 5,
            );
          else
            return CategoryDivider();
        },
      ),
    );
  }
}
