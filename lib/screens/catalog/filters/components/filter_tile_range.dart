import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/selectable_list.dart';
import 'package:refashioned_app/screens/components/sizes_table_link.dart';

class FilterTileRange extends StatefulWidget {
  final Filter filter;
  final Function() onUpdate;

  const FilterTileRange({Key key, this.filter, this.onUpdate}) : super(key: key);

  @override
  _FilterTileRangeState createState() => _FilterTileRangeState();
}

class _FilterTileRangeState extends State<FilterTileRange> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 23, bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: widget.filter.parameter == Parameter.size
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.filter.name,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizesTableLink(),
                    ],
                  )
                : Text(
                    widget.filter.name,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                  ),
          ),
          SizedBox(
            height: 17,
          ),
          SelectableList(
            horizontal: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            values: widget.filter.values,
            onSelect: (id) {
              HapticFeedback.selectionClick();

              setState(() {
                widget.filter.update(id: id);
              });
              if (widget.onUpdate != null) widget.onUpdate();
            },
          ),
        ],
      ),
    );
  }
}
