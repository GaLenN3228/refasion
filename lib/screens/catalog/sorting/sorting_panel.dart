import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/sorting/components/sorting_method_tile.dart';
import 'package:refashioned_app/screens/catalog/sorting/components/sorting_title.dart';

class SortingPanel extends StatefulWidget {
  final List<String> methods;
  final int initialSelected;
  final Function(int) onSelect;

  const SortingPanel(
      {Key key, this.methods, this.onSelect, this.initialSelected})
      : super(key: key);

  @override
  _SortingPanelState createState() => _SortingPanelState();
}

class _SortingPanelState extends State<SortingPanel> {
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
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SortingTitle(),
          ]..addAll(widget.methods.asMap().entries.map((e) => Column(
                children: [
                  if (e.key != 0) CategoryDivider(),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        selectIndex(e.key);
                        Navigator.of(context).pop();
                      },
                      child: SortMethodTile(
                          method: e.value, selected: e.key == selectedIndex)),
                ],
              ))),
        ),
      ),
    );
  }
}
