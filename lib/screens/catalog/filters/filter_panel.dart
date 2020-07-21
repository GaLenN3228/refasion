import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/catalog/filters/components/selectable_list.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_title.dart';

class FilterPanel extends StatefulWidget {
  final Filter filter;
  final Function() onUpdate;

  const FilterPanel({Key key, this.filter, this.onUpdate}) : super(key: key);

  @override
  _FilterPanelState createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  onReset() {
    setState(() {
      widget.filter.reset();
    });

    if (widget.onUpdate != null) widget.onUpdate();
  }

  onClose() {
    setState(() {
      widget.filter.reset(toPrevious: true);
    });

    if (widget.onUpdate != null) widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: Colors.white,
          child: Column(
            children: [
              FiltersTitle(
                onClose: onClose,
                filter: widget.filter,
                canReset: widget.filter.modified,
                onReset: onReset,
              ),
              Expanded(
                child: SelectableList(
                  values: widget.filter.values,
                  onSelect: (id) {
                    setState(() {
                      widget.filter.update(id: id);
                    });
                    if (widget.onUpdate != null) widget.onUpdate();
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomButton(
            action: () {
              widget.filter.save();
              Navigator.of(context).pop();
            },
            title: "ВЫБРАТЬ",
          ),
        )
      ],
    );
  }
}
