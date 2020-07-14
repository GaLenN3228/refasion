import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/filter_panel.dart';

class FilterTileList extends StatelessWidget {
  final Filter filter;

  const FilterTileList({Key key, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => showCupertinoModalBottomSheet(
            backgroundColor: Colors.white,
            expand: true,
            context: context,
            useRootNavigator: true,
            builder: (context, controller) => FilterPanel(
                  filter: filter,
                )),
        child: Text(
          filter.name,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
