import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/filters_panel.dart';

class FiltersButton extends StatelessWidget {
  final Function() onApply;
  final String root;
  final List<Filter> filters;

  const FiltersButton({Key key, this.onApply, this.root, this.filters})
      : super(key: key);

  showFilters(BuildContext context) {
    showCupertinoModalBottomSheet(
        expand: true,
        backgroundColor: Colors.white,
        context: context,
        useRootNavigator: true,
        builder: (context, controller) => FiltersPanel(
              filters: filters,
              root: root,
              scrollController: controller,
              updateProducts: onApply,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => showFilters(context),
        child: Row(
          children: [
            SizedBox(
              height: 27,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Фильтровать",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              width: 14,
            )
          ],
        ));
  }
}
