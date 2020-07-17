import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/selectable_list.dart';

class FilterTileRange extends StatefulWidget {
  final Filter filter;
  final Function() onUpdate;

  const FilterTileRange({Key key, this.filter, this.onUpdate})
      : super(key: key);

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
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              widget.filter.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w500),
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
