import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/filter_panel.dart';
import 'package:refashioned_app/utils/colors.dart';

class FilterTileList extends StatelessWidget {
  final Filter filter;
  final Function() onUpdate;

  const FilterTileList({Key key, this.filter, this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => showCupertinoModalBottomSheet(
          backgroundColor: Colors.white,
          expand: true,
          context: context,
          useRootNavigator: true,
          builder: (context, controller) =>
              FilterPanel(filter: filter, onUpdate: onUpdate)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 23),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  filter.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              filter.selectedValuesCount != 0
                  ? Container(
                      width: 17,
                      height: 17,
                      decoration: ShapeDecoration(
                          color: accentColor, shape: CircleBorder()),
                      child: Center(
                        child: Text(
                          filter.selectedValuesCount.toString(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.w500, color: primaryColor),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
